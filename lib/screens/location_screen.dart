import 'package:bechdal_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LocationScreen extends StatelessWidget {
  static const String screenId = 'location_screen';
  const LocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          FirebaseAuth.instance.signOut().then((value) =>
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (builder) => LoginScreen())));
        },
        child: Text('Sign Out'),
      )),
    );
  }
}
