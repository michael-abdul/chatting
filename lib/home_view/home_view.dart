import 'package:chatting_app/client_list_view.dart/client_list_view.dart';
import 'package:chatting_app/goup_chat/group_chat_view.dart';
import 'package:chatting_app/providers/web_socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class HomeView extends ConsumerWidget {
  final String name;

  const HomeView({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageNotifier = ref.watch(messageNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home View'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $name!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: Icon(Icons.group),
                title: Text('Group Chat'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupChatView(name: name),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('1:1 Chat'),
                onTap: () {
                  final connectedClients = messageNotifier.getClients();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientsListView(clients: connectedClients, currentUserName: name,),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
