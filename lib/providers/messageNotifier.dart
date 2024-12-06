import 'package:chatting_app/providers/web_socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatting_app/models/message.model.dart';
import 'package:chatting_app/services/web_socket_service.dart';

class MessageNotifier extends StateNotifier<List<Message>> {
  final WebSocketService _webSocketService;

  // TextEditingControllerlarni ichki boshqaruvda saqlash
  final TextEditingController groupTextController = TextEditingController();
  final TextEditingController privateTextController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  MessageNotifier(this._webSocketService) : super([]) {
    _initialize();
  }

  // WebSocket oqimni boshqarish
  void _initialize() {
    _webSocketService.messagesStream.listen((message) {
      state = [...state, message]; // Yangi xabarlarni holatga qo'shish
    });
  }

  // Guruh xabarini yuborish
  void sendGroupMessage() {
    if (groupTextController.text.isNotEmpty) {
      final message = Message(
        text: groupTextController.text,
        event: 'message',
      );
      _webSocketService.sendMessage(message);
      groupTextController.clear(); // Matnni tozalash
    }
  }

  // Shaxsiy xabarni yuborish
  void sendPrivateMessage() {
    if (privateTextController.text.isNotEmpty && toController.text.isNotEmpty) {
      final message = Message(
        text: privateTextController.text,
        event: 'message',
        to: toController.text,
      );
      _webSocketService.sendMessage(message);
      privateTextController.clear(); // Matnni tozalash
      toController.clear(); // Matnni tozalash
    }
  }

  // WebSocket ulanishni yopish
  void close() {
    _webSocketService.close();
    groupTextController.dispose();
    privateTextController.dispose();
    toController.dispose();
  }
}

// StateNotifierProvider yaratish
final messageNotifierProvider =
    StateNotifierProvider<MessageNotifier, List<Message>>((ref) {
  final webSocketService = ref.read(webSocketServiceProvider);
  return MessageNotifier(webSocketService);
});
