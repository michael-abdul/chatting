import 'package:chatting_app/providers/web_socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatting_app/models/message.model.dart';
import 'package:chatting_app/providers/messageNotifier.dart';

class ChatView extends ConsumerWidget {
  final String currentUserName;
  final String targetUserName;

  ChatView({
    Key? key,
    required this.currentUserName,
    required this.targetUserName,
  }) : super(key: key);

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Faqat currentUserName va targetUserName uchun filtrlangan xabarlar
    final messages = ref.watch(messageNotifierProvider).where((message) {
      return (message.from == currentUserName && message.to == targetUserName) ||
          (message.from == targetUserName && message.to == currentUserName);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with $targetUserName'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isSender = message.from == currentUserName;

                return Align(
                  alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSender ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(message.text),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final text = _messageController.text.trim();
                    if (text.isNotEmpty) {
                      ref.read(messageNotifierProvider.notifier).sendPrivateMessage(
                            currentUserName,
                            targetUserName,
                            text,
                          );
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}