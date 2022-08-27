import 'package:bechdal_app/components/common_page_widget.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions/functions.widgets.dart';
import 'package:bechdal_app/screens/auth/login_screen.dart';
import 'package:bechdal_app/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  static const screenId = 'welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonPageWidget(
      text: '',
      body: welcomeBodyWidget(context),
      containsAppbar: false,
      centerTitle: false,
    );
  }

  Widget welcomeBottomNavigationWidget(context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: roundedButton(
                context: context,
                bgColor: whiteColor,
                borderColor: blackColor,
                textColor: blackColor,
                text: 'Log In',
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.screenId);
                }),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: roundedButton(
                context: context,
                bgColor: primaryColor,
                text: 'Sign Up',
                textColor: whiteColor,
                onPressed: () {
                  Navigator.pushNamed(context, RegisterScreen.screenId);
                }),
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  Widget welcomeBodyWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 200,
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
        welcomeBottomNavigationWidget(context),
      ],
    );
  }
}
