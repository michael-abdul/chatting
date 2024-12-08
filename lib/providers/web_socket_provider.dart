import 'package:chatting_app/models/message.model.dart';
import 'package:chatting_app/providers/messageNotifier.dart';
import 'package:chatting_app/services/web_socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final userNameProvider = StateProvider<String>((ref) => "Unknown");
final webSocketServiceProvider = Provider<WebSocketService>((ref) {
final name = ref.watch(userNameProvider); // Foydalanuvchi ismini o'qish
  return WebSocketService('ws://localhost:3000', name); 
});

final messageNotifierProvider =
    StateNotifierProvider<MessageNotifier, List<Message>>((ref) {
  final webSocketService = ref.watch(webSocketServiceProvider);
  return MessageNotifier(webSocketService);
});
