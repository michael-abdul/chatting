
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatting_app/models/message.model.dart';
import 'package:chatting_app/services/web_socket_service.dart';
class MessageNotifier extends StateNotifier<List<Message>> {
  final WebSocketService _webSocketService;

  final TextEditingController groupTextController = TextEditingController();
List<String> connectedClients = [];

   MessageNotifier(this._webSocketService) : super([]) {
    _webSocketService.messagesStream.listen((event) {
      if (event is Map<String, dynamic> && event['event'] == 'message') {
        // Xabarni `Message` obyekti sifatida qayta ishlash
        final message = Message.fromJson(event);
        state = [...state, message]; // Yangi xabarni qo'shish
        print("New message added: ${message.text}, from: ${message.from}, to: ${message.to}");
      } else if (event is Map<String, dynamic> && event['event'] == 'info') {
        connectedClients = List<String>.from(event['clients'] ?? []);
        print("Connected clients updatedNotifier: $connectedClients");
        print("Info received: ${event['totalClients']} clients online.");
      }
    });
  }
    List<String> getClients() {
    return connectedClients;
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
  void sendPrivateMessage(String from, String to, String text) {
    final message = Message(
      text: text,
      event: 'message',
      from: from,
      to: to,
    );
    print("Sending private message: ${message.text}, from: ${message.from}, to: ${message.to}");
    _webSocketService.sendMessage(message);
  }

  void close() {
    _webSocketService.close();
    groupTextController.dispose();
  }
}
