import 'package:flutter/foundation.dart';
import '../services/websocket_service.dart';
import '../core/session_manager.dart';

class SessionState extends ChangeNotifier {
  Map<String, dynamic> state = {};

  void updateState(Map<String, dynamic> newState) {
    state = newState;
    notifyListeners();
  }

  /// Register handlers that update session state
  void registerHandlers(WebSocketService wss) {
    wss.on("sessionAck", (data) {
      // persist user data
      SessionManager.instance.saveUserData(data["userData"]);

      // update in-memory state
      updateState(data["state"] ?? {});
    });
    wss.on("stateUpdate", (data) {
      updateState(data["state"] ?? {});
    });
  }
}
