class Message {
  final String text;
  final String? to;
  final String? from;
  final String event;

  Message({
    required this.text,
    required this.event,
    this.to,
    this.from,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    // Tekshiruv: JSON tuzilmasi `data` maydoni bilan bo'lishi mumkin
    if (json.containsKey('data')) {
      return Message(
        text: json['data']['text'] as String? ?? 'No Text',
        event: json['event'] as String,
        to: json['data']['to'] as String?,
        from: json['data']['from'] as String?,
      );
    }

    // Tekshiruv: JSON tuzilmasi to'g'ridan-to'g'ri `text` maydonini saqlashi mumkin
    if (json.containsKey('text')) {
      return Message(
        text: json['text'] as String? ?? 'No Text',
        event: json['event'] as String,
        to: json['to'] as String?,
        from: json['from'] as String?,
      );
    }

    // JSON kutilgan formatga mos kelmasa
    throw FormatException('Invalid JSON format for Message: $json');
  }

  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'data': {
        'text': text,
        if (to != null) 'to': to,
        if (from != null) 'from': from,
      }
    };
  }
}
