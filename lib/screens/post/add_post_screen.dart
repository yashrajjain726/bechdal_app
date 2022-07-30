import 'package:flutter/material.dart';

class AddPostScreen extends StatelessWidget {
  static const screenId = 'add_post_screen';
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Center(child: Text('Add Post'),),
    );
  }
}
