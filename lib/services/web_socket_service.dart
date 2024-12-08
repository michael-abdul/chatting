import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:chatting_app/models/message.model.dart';
class WebSocketService {
  final WebSocketChannel _channel;
  Stream<Message>? _broadcastStream;

  WebSocketService(String url) : _channel = WebSocketChannel.connect(Uri.parse(url));

Stream<dynamic> get messagesStream {
  return _channel.stream.asBroadcastStream().map((data) {
    try {
      print("Raw data received: $data");
      final decodedData = jsonDecode(data);

      if (decodedData['event'] == 'message') {
        return Message.fromJson(decodedData); // Message turi uchun qaytariladi
      } else if (decodedData['event'] == 'info') {
        print("Info event received: ${decodedData['totalClients']} clients online.");
        return decodedData; // Info xabarlari uchun qaytariladi
      } else {
        print('Unhandled event type: ${decodedData['event']}');
        return null;
      }
    } catch (e) {
      print('Error decoding message: $e');
      print('Raw data: $data');
      rethrow;
    }
  }).where((event) => event != null); // Faqat null bo'lmagan xabarlarni streamdan o'tkazadi
}


void sendMessage(Message message) {
  try {
    final encodedMessage = jsonEncode(message.toJson());
    _channel.sink.add(encodedMessage); // JSON formatidagi ma'lumotni yuborish
    print("Message sent: $encodedMessage");
  } catch (e) {
    print('Error sending message: $e');
  }
}


  void close() {
    _channel.sink.close();
  }
}
