import 'package:chatting_app/models/client.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientNotifier extends StateNotifier<List<Client>> {
  ClientNotifier() : super([]);

  // Mijozlarni yangilash
 
  void updateClients(List<Map<String, dynamic>> clientsJson) {
    try {
      state = clientsJson.map((json) => Client.fromJson(json)).toList();
    } catch (e) {
      print('Error updating clients: $e');
    }
  }

  // Serverdan kelgan yangi client ro'yxatini qo'shish
  void addClient(Client client) {
    state = [...state, client];
  }
}

// Provider yaratish
final clientNotifierProvider =
    StateNotifierProvider<ClientNotifier, List<Client>>((ref) {
  return ClientNotifier();
});
