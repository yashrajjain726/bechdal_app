import 'dart:async';

import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions.constants.dart';
import 'package:bechdal_app/screens/home_screen.dart';
import 'package:bechdal_app/screens/location_screen.dart';
import 'package:bechdal_app/screens/login_screen.dart';
import 'package:bechdal_app/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String screenId = 'splash_screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () async {
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (user == null) {
          Navigator.pushReplacementNamed(context, WelcomeScreen.screenId);
        } else {
          fetchLocationAndAddress(
            context,
            selectedLocation,
            serviceEnabled,
            permission,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: whiteColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo_gif.gif",
              height: 300,
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
      ),
    );
  }
}
