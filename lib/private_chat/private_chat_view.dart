import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:chatting_app/providers/web_socket_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:chatting_app/services/upload_service.dart';

class ChatView extends ConsumerWidget {
  final String currentUserName;
  final String targetUserName;

  ChatView({
    super.key,
    required this.currentUserName,
    required this.targetUserName,
  });

  final TextEditingController _messageController = TextEditingController();

  String? _uploadedFileName;
  String? _uploadedFileUrl;

  Future<void> _pickAndUploadFile(BuildContext context, WidgetRef ref) async {
    final progress = ProgressHUD.of(context);

    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        final file = File(result.files.single.path!);

        progress?.showWithText('Uploading file...');
        final response = await uploadFile(file);
        progress?.dismiss();

        if (response != null) {
          _uploadedFileName = response['fileName'];
          _uploadedFileUrl = response['fileUrl'];
          _messageController.text = _uploadedFileName!;
        }
      }
    } catch (e) {
      progress?.dismiss();
      print('Error picking or uploading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messageNotifierProvider).where((message) {
      return message.event == 'message' &&
          ((message.from == currentUserName && message.to == targetUserName) ||
              (message.from == targetUserName && message.to == currentUserName));
    }).toList();

    return ProgressHUD(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Chat with $targetUserName'),
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
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isSender = message.from == currentUserName;

                      return Align(
                        alignment:
                            isSender ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          padding: const EdgeInsets.all(12),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6,
                          ),
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
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (message.text.isNotEmpty)
                                Text(
                                  message.text,
                                  style: TextStyle(
                                    color: isSender ? Colors.white : Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                              if (isSender && message.fileName != null && message.fileUrl != null)
                                GestureDetector(
                                  onTap: () async {
                                    await downloadAndOpenFile(
                                      context,
                                      message.fileUrl!,
                                      message.fileName!,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.attach_file,
                                          color: Colors.blueAccent,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          message.fileName!,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxHeight: 100),
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
                      IconButton(
                        icon: const Icon(Icons.attach_file, color: Colors.blueAccent),
                        onPressed: () async {
                          await _pickAndUploadFile(context, ref);
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.deepPurple),
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
                            _uploadedFileName = null;
                            _uploadedFileUrl = null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
