import 'dart:io';
import 'package:chatting_app/providers/web_socket_provider.dart';
import 'package:chatting_app/services/upload_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

class ChatView extends ConsumerWidget {
  final String currentUserName;
  final String targetUserName;

  ChatView({
    super.key,
    required this.currentUserName,
    required this.targetUserName,
  });

  final TextEditingController _messageController = TextEditingController();

  String? _uploadedFileName; // Yuklangan fayl nomi
  String? _uploadedFileUrl; // Yuklangan fayl URL

  Future<void> _pickAndUploadFile(WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        final file = File(result.files.single.path!);

        // Faylni yuklash
        final response = await uploadFile(file);
        if (response != null) {
          _uploadedFileName = response['fileName'];
          _uploadedFileUrl = response['fileUrl'];

          // Fayl yuklanganidan so'ng TextField ichida ko'rsatish
          _messageController.text =
              'File: ${_uploadedFileName!} (Click send to share)';
        }
      }
    } catch (e) {
      print('Fayl tanlash yoki yuklashda xatolik: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messageNotifierProvider).where((message) {
      return message.event == 'message' &&
          ((message.from == currentUserName && message.to == targetUserName) ||
              (message.from == targetUserName &&
                  message.to == currentUserName));
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
                  alignment:
                      isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: isSender
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (!isSender)
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 5.0),
                          child: Text(
                            targetUserName,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700]),
                          ),
                        ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSender ? Colors.blue[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(message.text),
                            if (message.fileName != null &&
                                message.fileUrl != null)
                              GestureDetector(
                                onTap: () {
                                  // Faylni yuklash
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Downloading ${message.fileName}...'),
                                    ),
                                  );
                                  // Faylni yuklash yoki brauzerda ochish uchun
                                  print('File URL: ${message.fileUrl}');
                                },
                                child: Text(
                                  'File: ${message.fileName}',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                          ],
                        ),
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
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () async {
                    await _pickAndUploadFile(ref);
                  },
                ),
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
                      ref
                          .read(messageNotifierProvider.notifier)
                          .sendPrivateMessage(
                            currentUserName,
                            targetUserName,
                            text,
                            fileName: _uploadedFileName,
                            fileUrl: _uploadedFileUrl,
                          );

                      _messageController.clear();
                      _uploadedFileName = null; // Faylni tozalash
                      _uploadedFileUrl = null; // Faylni tozalash
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
