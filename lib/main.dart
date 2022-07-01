import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/screens/auth/otp_screen.dart';
import 'package:bechdal_app/screens/auth/phone_auth_screen.dart';
import 'package:bechdal_app/screens/home_screen.dart';
import 'package:bechdal_app/screens/location_screen.dart';
import 'package:bechdal_app/screens/login_screen.dart';
import 'package:bechdal_app/screens/register_screen.dart';
import 'package:bechdal_app/screens/splash_screen.dart';
import 'package:bechdal_app/screens/welcome_screen.dart';
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
    return MaterialApp(
      theme: ThemeData(
        primaryColor: blackColor,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.screenId,
      routes: {
        SplashScreen.screenId: (context) => SplashScreen(),
        LoginScreen.screenId: (context) => LoginScreen(),
        PhoneAuthScreen.screenId: (context) => PhoneAuthScreen(),
        LocationScreen.screenId: (context) => LocationScreen(),
        HomeScreen.screenId: (context) => HomeScreen(),
        WelcomeScreen.screenId: (context) => WelcomeScreen(),
        RegisterScreen.screenId: (context) => RegisterScreen()
      },
    );
  }
}
