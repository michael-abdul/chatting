import 'package:chatting_app/home_view/home_view.dart';
import 'package:chatting_app/providers/web_socket_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


mixin class FirstViewManager {
  final TextEditingController nameController = TextEditingController();

  navigateToChatView(BuildContext context, WidgetRef ref) {
     final name = nameController.text.trim();
  if (name.isEmpty) {
    print("Name is empty. Please enter a valid name.");
    return;
  }
  print("Name entered: $name");
    ref.read(userNameProvider.notifier).state = name; // Foydalanuvchi ismini o'rnatish
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => HomeView(name:name),
      ),
    );
  }
}
