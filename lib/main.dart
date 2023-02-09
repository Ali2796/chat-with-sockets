import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_chat_flutter/repository/data_client/user_client.dart';
import 'package:socket_io_chat_flutter/screens/chat/chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserClient>(
      create: (context) => UserClient(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ChatScreen(),
      ),
    );
  }
}
