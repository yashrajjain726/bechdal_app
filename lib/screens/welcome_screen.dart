import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions.constants.dart';
import 'package:bechdal_app/screens/login_screen.dart';
import 'package:bechdal_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  static const screenId = 'welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return appBarWidget(context, '', welcomeBodyWidget(context), false, false,
        bottomNavigation: welcomeBottomNavigationWidget(context));
  }

  Widget welcomeBottomNavigationWidget(context) {
    return SafeArea(
      child: Container(
        height: 150,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: roundedButton(
                  context: context,
                  bgColor: whiteColor,
                  borderColor: blackColor,
                  textColor: blackColor,
                  text: 'LOG IN',
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.screenId);
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: roundedButton(
                  context: context,
                  bgColor: primaryColor,
                  text: 'SIGN UP',
                  textColor: whiteColor,
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterScreen.screenId);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget welcomeBodyWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 250,
          child: Padding(
            padding: EdgeInsets.only(top: 80, left: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bechdal',
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Sell your un-needs here',
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Lottie.asset(
                'assets/lottie/welcome_lottie.json',
                width: double.infinity,
                height: 350,
              ),
            )
          ]),
        ),
      ],
    );
  }
}
