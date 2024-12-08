
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatting_app/models/message.model.dart';
import 'package:chatting_app/services/web_socket_service.dart';
class MessageNotifier extends StateNotifier<List<Message>> {
  final WebSocketService _webSocketService;

  final TextEditingController groupTextController = TextEditingController();

  MessageNotifier(this._webSocketService) : super([]) {
    _webSocketService.messagesStream.listen((event) {
      if (event is Message) {
        state = [...state, event];
      } else if (event is Map<String, dynamic> && event['event'] == 'info') {
        print("Info received: ${event['totalClients']} clients online.");
      }
    });
  }


  void sendGroupMessage(String name) {
    if (groupTextController.text.isNotEmpty) {
      final message = Message(
        text: groupTextController.text,
        event: 'message',
        from: name,
      );
        print("Sending message: ${message.text}, from: ${message.from}");
      _webSocketService.sendMessage(message);
      groupTextController.clear();
    }
  }

  void close() {
    _webSocketService.close();
    groupTextController.dispose();
  }
}
