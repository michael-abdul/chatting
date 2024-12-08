import 'package:chatting_app/first_view/first_view_manager.dart';
import 'package:flutter/material.dart';


class FirstView extends StatelessWidget with FirstViewManager {
  FirstView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
              controller: nameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
                onPressed: () => navigateToChatView(context),
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
