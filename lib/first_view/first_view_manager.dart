import 'package:chatting_app/home_view/home_view.dart';
import 'package:flutter/cupertino.dart';


mixin class FirstViewManager {
  final TextEditingController nameController = TextEditingController();

  navigateToChatView(BuildContext context) {
     final name = nameController.text.isNotEmpty ? nameController.text : "Unknown";
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => HomeView(name:name),
      ),
    );
  }
}
