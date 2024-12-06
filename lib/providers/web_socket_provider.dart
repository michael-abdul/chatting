import 'package:chatting_app/services/web_socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// WebSocket Service Provider
final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  return WebSocketService('ws://localhost:3000');
});
