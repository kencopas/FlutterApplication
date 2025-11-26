import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../core/wsp_event.dart';
import '../core/session_manager.dart';
import '../core/session_state.dart';

class WebSocketService extends ChangeNotifier {
  WebSocketChannel? _channel;

  bool isConnected = false;
  List<String> messages = [];
  Map<String, dynamic>? lastPropertyEvent;

  final Map<String, void Function(Map<String, dynamic>)> handlers = {};
  final String url;
  final SessionState sessionState;

  WebSocketService(this.url, this.sessionState);

  // Register handler
  void on(String event, Function(Map<String, dynamic>) handler) {
    handlers[event] = handler;
  }

  Future<void> connect() async {
    _channel = WebSocketChannel.connect(Uri.parse(url));

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

    isConnected = true;
    notifyListeners();

    await sendEvent("sessionInit");
  }

  void _handleMessage(String raw) {
    print("Received: $raw");

    final jsonMsg = jsonDecode(raw);
    final event = jsonMsg["event"];
    final data = jsonMsg["data"] ?? {};

    messages.add(raw);
    notifyListeners();

    final handler = handlers[event];
    if (handler != null) {
      handler(data);
    } else {
      print("No handler registered for event: $event");
    }
  }

  Future<void> sendEvent(String event, [Map<String, dynamic>? payload]) async {
    final wsp = await WSPEvent.build(event, payload ?? {});
    final text = jsonEncode(wsp.toJson());
    _channel?.sink.add(text);
  }

  @override
  void dispose() {
    SessionManager.instance.clearSessionId();
    _channel?.sink.close();
    super.dispose();
  }
}
