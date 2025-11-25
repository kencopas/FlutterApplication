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

    // Send sessionInit
    final sessionId = await SessionManager.instance.sessionId;
    final userId = await SessionManager.instance.userId;

    send(
      WSPEvent(
        event: "sessionInit",
        data: {"sessionId": sessionId, "userId": userId},
      ),
    );
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

  void send(WSPEvent event) {
    final text = jsonEncode(event.toJson());
    _channel?.sink.add(text);
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}
