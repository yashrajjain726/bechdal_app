import 'package:flutter/material.dart';

class MyPostScreen extends StatelessWidget {
  static const screenId = 'my_post_screen';
  const MyPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('My Post'),),
    );
  }
}
