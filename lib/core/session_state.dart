import 'package:flutter/foundation.dart';
import '../services/websocket_service.dart';
import '../core/session_manager.dart';

class SessionState extends ChangeNotifier {
  /// ```
  /// {
  ///   "userId": String,
  ///   "money_dollars": int,
  ///   "position": int,
  ///   "current_space_id": String,
  ///   "board_spaces": [
  ///     {
  ///       "name": String,
  ///       "space_type": String,
  ///       "space_id": String,
  ///       "space_index": int,
  ///       "visual_properties": {
  ///         "color": String?,
  ///         "icon": String?,
  ///         "description": String?,
  ///         "occupied_by": String?
  ///       }
  ///     },
  ///     ...
  ///   ],
  /// }
  /// ```
  Map<String, dynamic> state = {};

  /// Update session state and notify listeners
  void updateState(Map<String, dynamic> newState) {
    state = newState;
    print("Session state updated: $state");
    notifyListeners();
  }

  /// Register session handlers
  void registerHandlers(WebSocketService wss) {
    // Session acknowledgment handler
    wss.on("sessionAck", (data) {
      SessionManager.instance.saveUserData(data["userData"]);
      updateState(data["state"] ?? {});
    });

    // State update handler
    wss.on("stateUpdate", (data) {
      updateState(data["state"] ?? {});
    });
  }
}
