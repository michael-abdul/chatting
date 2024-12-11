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
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 181, 162, 214), Color.fromARGB(255, 126, 141, 226)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: clients.length,
          itemBuilder: (context, index) {
            final client = clients[index];

            if (client == currentUserName) {
              // Joriy foydalanuvchini ro'yxatda ko'rsatmaymiz
              return const SizedBox.shrink();
            }

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.deepPurpleAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  client,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
                trailing: const Icon(
                  Icons.chat,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
