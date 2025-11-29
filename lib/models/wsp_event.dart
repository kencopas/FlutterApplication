import '../core/session_manager.dart';

class WSPEvent {
  final String event;
  final Map<String, dynamic> data;

  WSPEvent({required this.event, required this.data});

  /// Build WSPEvent with sessionId and userId included
  static Future<WSPEvent> build(
    String event,
    Map<String, dynamic> payload,
  ) async {
    final sessionId = await SessionManager.instance.sessionId;
    final userId = await SessionManager.instance.userId;

    return WSPEvent(
      event: event,
      data: {"sessionId": sessionId, "userId": userId, ...payload},
    );
  }

  Map<String, dynamic> toJson() => {"event": event, "data": data};
}
