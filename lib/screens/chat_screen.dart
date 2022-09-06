import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  static const screenId = 'chat_screen';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('ChatScreen'),
      ),
    );
  }
}
