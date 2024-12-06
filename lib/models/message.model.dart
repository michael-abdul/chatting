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

  factory Message.fromJson(Map<String, dynamic>? json) {
    // JSON-ni tekshirish va noto'g'ri ma'lumotlarni qaytarish
    if (json == null || json['data'] == null || json['event'] == null) {
      throw FormatException('Invalid JSON format for Message: $json');
    }

    return Message(
      text: json['data']['text'] as String? ?? 'No Text', // Default qiymat qo'shildi
      event: json['event'] as String,
      to: json['data']['to'] as String?,
      from: json['data']['from'] as String?,
    );
  }


  Map<String, dynamic> toJson() {
    final data = {'text': text};
    if (to != null) data['to'] = to!;
    if (from != null) data['from'] = from!;

    return {
      'event': event,
      'data': data,
    };
  }
}
class InfoPayload {
  final String event;
  final int totalClients;

  InfoPayload({
    required this.event,
    required this.totalClients,
  });

 factory InfoPayload.fromJson(Map<String, dynamic>? json) {
    // JSON-ni tekshirish va noto'g'ri ma'lumotlarni qaytarish
    if (json == null || json['event'] == null || json['totalClients'] == null) {
      throw FormatException('Invalid JSON format for InfoPayload: $json');
    }

    return InfoPayload(
      event: json['event'] as String,
      totalClients: json['totalClients'] as int,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'totalClients': totalClients,
    };
  }
}