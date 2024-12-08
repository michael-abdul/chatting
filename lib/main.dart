// import 'package:chatting_app/providers/messageNotifier.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';


// void main() => runApp(const ProviderScope(child: MyApp()));

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const title = 'WebSocket Demo';
//     return const MaterialApp(
//       title: title,
//       home: MyHomePage(
//         title: title,
//       ),
//     );
//   }
// }

// class MyHomePage extends ConsumerWidget {
//   const MyHomePage({
//     super.key,
//     required this.title,
//   });

//   final String title;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // MessageNotifier va xabar holatini olish
//     final messages = ref.watch(messageNotifierProvider);
//     final messageNotifier = ref.read(messageNotifierProvider.notifier);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Form(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     '개인 메시지:',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   TextFormField(
//                     controller: messageNotifier.privateTextController,
//                     decoration: const InputDecoration(labelText: '개인 메시지를 입력하세요'),
//                   ),
//                   const SizedBox(height: 8),
//                   TextFormField(
//                     controller: messageNotifier.toController,
//                     decoration: const InputDecoration(labelText: '받는 사람 ID를 입력하세요'),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     '그룹 메시지:',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   TextFormField(
//                     controller: messageNotifier.groupTextController,
//                     decoration: const InputDecoration(labelText: '그룹 메시지를 입력하세요'),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: messages.length,
//                 itemBuilder: (context, index) {
//                   final message = messages[index];
//                   return ListTile(
//                     title: Text(message.text),
//                     subtitle: Text(message.from ?? 'Unknown'),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             onPressed: messageNotifier.sendPrivateMessage,
//             tooltip: '개인 메시지 전송',
//             child: const Icon(Icons.person),
//           ),
//           const SizedBox(height: 10),
//           FloatingActionButton(
//             onPressed: messageNotifier.sendGroupMessage,
//             tooltip: '그룹 메시지 전송',
//             child: const Icon(Icons.group),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:chatting_app/first_view/first_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: FirstView(),
      ),
    ),
  );
}
