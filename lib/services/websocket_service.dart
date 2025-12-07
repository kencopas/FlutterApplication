import 'dart:convert';
import 'package:dart_frontend/core/state_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/wsp_event.dart';

class WebSocketService extends ChangeNotifier {
  WebSocketChannel? _channel;

  bool isConnected = false;
  bool _initialized = false;
  List<String> messages = [];
  Map<String, dynamic>? lastPromptEvent;

  final Map<String, void Function(Map<String, dynamic>)> handlers = {};
  final String url;
  final StateManager stateManager;

  WebSocketService(this.url, this.stateManager);

  void init() {
    if (_initialized) return;
    _initialized = true;

    connect();

    // register handlers
    stateManager.registerHandlers(this);

    // Game logic handlers
    on("showDialog", (data) {
      lastPromptEvent = data;
      notifyListeners();
    });
  }

  /// Register handler
  void on(String event, void Function(Map<String, dynamic>) handler) {
    handlers[event] = handler;
  }

  /// Connect to WebSocket server, initialize sesison with `sessionInit` event
  Future<void> connect() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
    } catch (e) {
      print('Failed to connect to websocket server');
      return;
    }

    // Listen for messages
    _channel!.stream.listen(
      (raw) {
        if (raw is String) {
          _handleMessage(raw);
        }
      },
      onError: (e) {
        isConnected = false;
        notifyListeners();
      },
      onDone: () {
        isConnected = false;
        notifyListeners();
      },
    );

    await _channel!.ready;
    isConnected = true;
    notifyListeners();

    await sendEvent("sessionInit");
  }

  /// Handle incoming message by parsing JSON, notifying listeners, and dispatching to registered handler
  void _handleMessage(String raw) {
    print(
      "Received: ${raw.substring(0, raw.length > 500 ? 500 : raw.length)}${raw.length > 500 ? "... [TRUNCATED]" : ""}",
    );

    final jsonMsg = Map<String, dynamic>.from(jsonDecode(raw));

    final event = jsonMsg["event"];

    // Extract data safely
    final rawData = jsonMsg["data"];
    final data = rawData is Map
        ? Map<String, dynamic>.from(rawData)
        : <String, dynamic>{};

    messages.add(raw);
    notifyListeners();

    final handler = handlers[event];
    if (handler != null) {
      handler(data);
    } else {
      print("No handler registered for event: $event");
    }
  }

  /// Send WSP Event to WebSocket server
  Future<void> sendEvent(String event, [Map<String, dynamic>? payload]) async {
    final wsp = await WSPEvent.build(event, payload ?? {});
    final text = jsonEncode(wsp.toJson());
    _channel?.sink.add(text);
  }

  /// Clean up resources
  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}
