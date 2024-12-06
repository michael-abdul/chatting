import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  final String url = 'ws://localhost:3000';
  WebSocketChannel? _channel;

  // WebSocket ulanishni o'rnatish
  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    print('WebSocket Connection success');
  }

  // WebSocket ulanishni yopish
  void disconnect() {
    _channel?.sink.close();
    print('WebSocket disconnected');
  }

  // Xabar yuborish
  void sendMessage(Map<String, dynamic> message) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(message));
    } else {
      print('Error: WebSocket is not connected.');
    }
  }

  // Kelayotgan xabarlarni tinglash
  Stream<Map<String, dynamic>> get messages {
    if (_channel != null) {
      return _channel!.stream.map((message) {
        return jsonDecode(message) as Map<String, dynamic>;
      });
    } else {
      throw Exception('WebSocket is not connected.');
    }
  }
}
