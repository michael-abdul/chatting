import 'package:chatting_app/providers/web_socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatting_app/models/message.model.dart';
import 'package:chatting_app/providers/messageNotifier.dart';

class GroupChatView extends ConsumerWidget {
  final String name;

  const GroupChatView({super.key, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Faqat guruh xabarlari uchun (event == 'groupmessage') xabarlarni filtrlaymiz
    final groupMessages = ref.watch(messageNotifierProvider).where((message) {
      return message.event == 'groupmessage'; // Faqat 'groupmessage' eventini ko'rsatish
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: groupMessages.length,
              itemBuilder: (context, index) {
                final message = groupMessages[index];
                final isSender = message.from == name;

                return Align(
                  alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSender ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(message.text), // Faqat xabar matni chiqariladi
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
                    controller: ref.watch(messageNotifierProvider.notifier).groupTextController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final text = ref
                        .read(messageNotifierProvider.notifier)
                        .groupTextController
                        .text
                        .trim();
                    if (text.isNotEmpty) {
                      ref.read(messageNotifierProvider.notifier).sendGroupMessage(name);
                    }
                  },
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
