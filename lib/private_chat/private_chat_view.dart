import 'package:chatting_app/providers/web_socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatView extends ConsumerWidget {
  final String currentUserName;
  final String targetUserName;

  ChatView({
    super.key,
    required this.currentUserName,
    required this.targetUserName,
  });

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Filter messages for 1:1 chat (event == 'message')
    final messages = ref.watch(messageNotifierProvider).where((message) {
      return message.event == 'message' && // Ensure the event is 'message'
          ((message.from == currentUserName && message.to == targetUserName) ||
              (message.from == targetUserName && message.to == currentUserName));
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
                  child: Column(
                    crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      // Show the target user's name for their messages
                      if (!isSender)
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                          child: Text(
                            targetUserName,
                            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                          ),
                        ),
                      // Display the message
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSender ? Colors.blue[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(message.text),
                      ),
                    ],
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
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
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
