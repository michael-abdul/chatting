import 'package:chatting_app/private_chat/private_chat_view.dart';
import 'package:flutter/material.dart';

class ClientsListView extends StatelessWidget {
  final List<String> clients; // Mijozlar ro'yxati
  final String currentUserName; // Joriy foydalanuvchi nomi

  const ClientsListView({
    super.key,
    required this.clients,
    required this.currentUserName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected Clients'),
      ),
      body: ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          final client = clients[index];
          if (client == currentUserName) {
            // Joriy foydalanuvchini ro'yxatda ko'rsatmaymiz
            return const SizedBox.shrink();
          }
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(client),
            onTap: () {
              // 1:1 chatga o'tish uchun navigatsiya qilish
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatView(
                    currentUserName: currentUserName,
                    targetUserName: client,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
