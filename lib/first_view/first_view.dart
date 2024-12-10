import 'package:chatting_app/first_view/first_view_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirstView extends ConsumerWidget with FirstViewManager {
  FirstView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Enter your name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
                onPressed: () => navigateToChatView(context, ref), // `ref`ni uzatish
                child: const Text(
                  "Let's Chat",
                  style: TextStyle(fontSize: 20),
                )),
          )
        ],
      ),
    );
  }
}
