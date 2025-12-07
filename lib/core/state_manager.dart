import '../services/websocket_service.dart';
import '../models/game_state.dart';
import 'package:flutter/foundation.dart';

class StateManager extends ChangeNotifier {
  GameState? state;

  StateManager();

  /// Update session state and notify listeners
  void updateState(Map<String, dynamic> newState) {
    if (newState.isEmpty) return;
    state = GameState.fromJson(newState);
    print("Session state updated: $state");
    notifyListeners();
  }

  /// Register session handlers
  void registerHandlers(WebSocketService wss) {
    // Session acknowledgment handler
    wss.on("sessionAck", (data) {
      updateState(data["state"] ?? {});
    });

    // State update handler
    wss.on("stateUpdate", (data) {
      updateState(data["state"] ?? {});
    });
  }
}
