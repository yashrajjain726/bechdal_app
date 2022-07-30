import 'package:bechdal_app/screens/main_navigatiion_screen.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/screens/auth/email_verify_screen.dart';
import 'package:bechdal_app/screens/auth/phone_auth_screen.dart';
import 'package:bechdal_app/screens/auth/reset_password_screen.dart';
import 'package:bechdal_app/screens/category/subcategory_screen.dart';
import 'package:bechdal_app/screens/home_screen.dart';
import 'package:bechdal_app/screens/location_screen.dart';
import 'package:bechdal_app/screens/auth/login_screen.dart';
import 'package:bechdal_app/screens/auth/register_screen.dart';
import 'package:bechdal_app/screens/splash_screen.dart';
import 'package:bechdal_app/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/category/category_list_screen.dart';

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
          backgroundColor: whiteColor
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.screenId,
        routes: {
          SplashScreen.screenId: (context) => const SplashScreen(),
          LoginScreen.screenId: (context) => const LoginScreen(),
          PhoneAuthScreen.screenId: (context) => const PhoneAuthScreen(),
          LocationScreen.screenId: (context) => const LocationScreen(),
          HomeScreen.screenId: (context) => const HomeScreen(),
          WelcomeScreen.screenId: (context) => const WelcomeScreen(),
          RegisterScreen.screenId: (context) => const RegisterScreen(),
          EmailVerifyScreen.screenId: (context) => const EmailVerifyScreen(),
          ResetPasswordScreen.screenId: (context) =>
              const ResetPasswordScreen(),
          CategoryListScreen.screenId:(context)=>const CategoryListScreen(),
          SubCategoryScreen.screenId:(context)=>const SubCategoryScreen(),
          MainNavigationScreen.screenId:(context)=>const MainNavigationScreen()


        });
  }
}
