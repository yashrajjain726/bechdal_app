import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const screenId =  'profile_screen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('Profile'),),
    );
  }
}
