import 'package:chatting_app/goup_chat/group_chat_view.dart';
import 'package:flutter/material.dart';


class HomeView extends StatelessWidget {
  final String name;

  const HomeView({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  // 1:1 chatga o'tish funksiyasi
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('1:1 Chat clicked!')),
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
