import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:chatting_app/models/message.model.dart';

class WebSocketService {
  final WebSocketChannel _channel;

  WebSocketService(String url, String userName)
      : _channel = WebSocketChannel.connect(Uri.parse(url)) {
    _sendRegisterEvent(userName);
  }

  // Foydalanuvchi ismini `register` eventi orqali jo'natish
  void _sendRegisterEvent(String userName) {
    try {
      final registerMessage = jsonEncode({
        'event': 'register',
        'name': userName,
      });
      _channel.sink.add(registerMessage);
      print("Register event sent: $registerMessage");
    } catch (e) {
      print("Error sending register event: $e");
    }
  }

  Stream<dynamic> get messagesStream {
    return _channel.stream.asBroadcastStream().map((data) {
      try {
        print("Raw data received: $data");
        final decodedData = jsonDecode(data);
        return decodedData;
      } catch (e) {
        print("Error decoding message: $e");
        return null;
      }
    }).where((event) => event != null);
  }

  void sendMessage(Message message) {
    try {
      final encodedMessage = jsonEncode(message.toJson());
      _channel.sink.add(encodedMessage);
      print("Message sent: $encodedMessage");
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  void close() {
    _channel.sink.close();
  }
}
