class Message {
  final String text;
  final String? to;
  final String? from;

  Message({required this.text, this.to, this.from});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      to: json['to'],
      from: json['from'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'to': to,
      'from': from,
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


  factory InfoPayload.fromJson(Map<String, dynamic> json) {
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