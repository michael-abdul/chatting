import 'package:chatting_app/providers/web_socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color.fromARGB(255, 208, 192, 236), Color.fromARGB(255, 132, 147, 230)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
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
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSender
                            ? Colors.deepPurpleAccent.withOpacity(0.8)
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: isSender
                              ? const Radius.circular(12)
                              : Radius.zero,
                          bottomRight: isSender
                              ? Radius.zero
                              : const Radius.circular(12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: isSender ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: ref
                          .watch(messageNotifierProvider.notifier)
                          .groupTextController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 10),
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
                    color: Colors.deepPurpleAccent,
                    iconSize: 28,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
