import 'dart:convert';
import 'package:chatting_app/models/client.model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:chatting_app/models/message.model.dart';

class WebSocketService {
  final WebSocketChannel _channel;

  WebSocketService(String url) : _channel = WebSocketChannel.connect(Uri.parse(url));

  // Xabarlarni olish
  Stream<Message> get messagesStream {
    return _channel.stream.map((data) {
      try {
        final decodedData = jsonDecode(data);
        if (decodedData['event'] == 'message') {
          return Message.fromJson(decodedData);
        }
        throw FormatException('Unexpected event: ${decodedData['event']}');
      } catch (e) {
        print('Error decoding message: $e');
        rethrow;
      }
    });
  }

  // Mijozlarni olish
  Stream<List<Client>> get clientsStream {
    return _channel.stream.map((data) {
      try {
        final decodedData = jsonDecode(data);
        if (decodedData['event'] == 'clients_update') {
          return (decodedData['clients'] as List)
              .map((client) => Client.fromJson(client))
              .toList();
        }
        return [];
      } catch (e) {
        print('Error decoding clients: $e');
        return [];
      }
    });
  }

  // Xabar yuborish
  void sendMessage(Message message) {
    try {
      _channel.sink.add(jsonEncode(message.toJson()));
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  // Ulashni yopish
  void close() {
    _channel.sink.close();
  }
}
