class WSPEvent {
  final String event;
  final Map<String, dynamic> data;

  WSPEvent({
    required this.event,
    required this.data,
  });

  Map<String, dynamic> toJson() => {
        "event": event,
        "data": data,
      };
}
