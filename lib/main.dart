import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _groupTextController = TextEditingController();
  final TextEditingController _privateTextController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:3000'), // Serverga mos URL
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '개인 메시지:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _privateTextController,
                    decoration: const InputDecoration(labelText: '개인 메시지를 입력하세요'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _toController,
                    decoration: const InputDecoration(labelText: '받는 사람 ID를 입력하세요'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '그룹 메시지:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _groupTextController,
                    decoration: const InputDecoration(labelText: '그룹 메시지를 입력하세요'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return Text(snapshot.hasData ? '${snapshot.data}' : 'No message received');
              },
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _sendPrivateMessage,
            tooltip: '개인 메시지 전송',
            child: const Icon(Icons.person),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _sendGroupMessage,
            tooltip: '그룹 메시지 전송',
            child: const Icon(Icons.group),
          ),
        ],
      ),
    );
  }

  // Private Message
  void _sendPrivateMessage() {
    if (_privateTextController.text.isNotEmpty && _toController.text.isNotEmpty) {
      final message = {
        'event': 'message',
        'data': {
          'text': _privateTextController.text,
          'to': _toController.text,
        }
      };
      _channel.sink.add(jsonEncode(message)); // JSON formatida yuborish
    }
  }

  // Group Message
  void _sendGroupMessage() {
    if (_groupTextController.text.isNotEmpty) {
      final message = {
        'event': 'message',
        'data': {
          'text': _groupTextController.text,
        }
      };
      _channel.sink.add(jsonEncode(message)); // JSON formatida yuborish
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _groupTextController.dispose();
    _privateTextController.dispose();
    _toController.dispose();
    super.dispose();
  }
}
