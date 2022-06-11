import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/screens/login_screen.dart';
import 'package:bechdal_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(
          seconds: 5,
        )),
        builder: (context, snapshot) {
          return MaterialApp(
            theme: ThemeData(
              primaryColor: blackColor,
            ),
            debugShowCheckedModeBanner: false,
            home: (snapshot.connectionState == ConnectionState.waiting)
                ? SplashScreen()
                : LoginScreen(),
          );
        });
  }
}
