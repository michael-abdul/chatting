import 'package:chatting_app/models/message.model.dart';
import 'package:chatting_app/services/web_socket_channel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebSocketState {
  final bool isConnected;
  final List<Message> messages;
  final InfoPayload? info;

  WebSocketState({
    required this.isConnected,
    required this.messages,
    this.info,
  });

  WebSocketState copyWith({
    bool? isConnected,
    List<Message>? messages,
    InfoPayload? info,
  }) {
    return WebSocketState(
      isConnected: isConnected ?? this.isConnected,
      messages: messages ?? this.messages,
      info: info ?? this.info,
    );
  }
}

class WebSocketNotifier extends StateNotifier<WebSocketState> {
  final WebSocketClient client;

  WebSocketNotifier(this.client)
      : super(WebSocketState(isConnected: false, messages: []));

  // WebSocket ulanishini boshlash
  void connect() {
    client.connect();
    state = state.copyWith(isConnected: true);

    client.messages.listen((message) {
      if (message['event'] == 'message') {
        final newMessage = Message.fromJson(message);
        state = state.copyWith(messages: [...state.messages, newMessage]);
      } else if (message['event'] == 'info') {
        final info = InfoPayload.fromJson(message);
        state = state.copyWith(info: info);
      }
    });
  }

  // Xabar yuborish
  void sendMessage(Message message) {
    client.sendMessage(message.toJson());
  }

  // WebSocket ulanishini yopish
  void disconnect() {
    client.disconnect();
    state = state.copyWith(isConnected: false);
  }
}

final webSocketProvider = StateNotifierProvider<WebSocketNotifier, WebSocketState>((ref) {
  final client = WebSocketClient();
  return WebSocketNotifier(client);
});
