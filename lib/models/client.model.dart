class Client {
  final String clientId;
  final String name;

  Client({required this.clientId, required this.name});

  factory Client.fromJson(Map<String, dynamic>? json) {
    if (json == null || json['clientId'] == null || json['name'] == null) {
      throw FormatException('Invalid JSON format for Client: $json');
    }

    return Client(
      clientId: json['clientId'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'name': name,
    };
  }
}
