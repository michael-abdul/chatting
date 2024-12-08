import 'package:chatting_app/home_view/home_view.dart';
import 'package:chatting_app/providers/web_socket_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


mixin class FirstViewManager {
  final TextEditingController nameController = TextEditingController();

  navigateToChatView(BuildContext context, WidgetRef ref) {
    final name = nameController.text.isNotEmpty ? nameController.text : "Unknown";
    ref.read(userNameProvider.notifier).state = name; // Foydalanuvchi ismini o'rnatish
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => HomeView(name:name),
      ),
    );
  }
}
