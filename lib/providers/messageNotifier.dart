
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatting_app/models/message.model.dart';
import 'package:chatting_app/services/web_socket_service.dart';
class MessageNotifier extends StateNotifier<List<Message>> {
  final WebSocketService _webSocketService;
 final Map<String, String> clientMap = {};
  final TextEditingController groupTextController = TextEditingController();
List<String> connectedClients = [];

MessageNotifier(this._webSocketService) : super([]) {
  _webSocketService.messagesStream.listen((event) {
    // Kelgan voqeani tekshirish
    if (event is Map<String, dynamic>) {
      if  (event['event'] == 'message' || event['event'] == 'groupmessage') {
        // Xabarni `Message` obyekti sifatida qayta ishlash
        final message = Message.fromJson(event);
        state = [...state, message]; // Yangi xabarni qo'shish
      print("Notifier state updated: $state");
      } else if (event['event'] == 'info') {
        // Mijozlar ro'yxatini yangilash
        connectedClients = List<String>.from(event['clients'] ?? []);
        print("Connected clients updatedNotifier: $connectedClients");
        state = [...state]; // State'ni yangilash
      }
    } else {
      print("Unknown event type received: $event");
    }
  });
}

List<String> getClients() {
  // Hozirgi ulangan mijozlarni qaytaradi
  return connectedClients;
}


  void sendGroupMessage(String name) {
    if (groupTextController.text.isNotEmpty) {
      final message = Message(
        text: groupTextController.text,
        event: 'groupmessage',
        from: name,
      );
   print("Message sent: $message");
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
