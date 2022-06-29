import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/screens/auth/phone_auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatelessWidget {
  static const String screenId = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Lottie.asset(
                "assets/lottie/login_lottie.json",
                height: 300,
                width: 300,
              ),
              height: MediaQuery.of(context).size.height / 2,
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const PhoneAuthScreen()));
                      },
                      child: signInButtons('assets/phone.png',
                          'Sign in with Phone Number', whiteColor, context),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    signInButtons('assets/google.png', 'Sign in with Google',
                        whiteColor, context),
                    const SizedBox(
                      height: 10,
                    ),
                    signInButtons('assets/facebook.png',
                        'Sign in with Facebook', facebookBgColor, context),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Login with Email',
                      style: TextStyle(
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: termsAndConditionBanner())
          ]),
    );
  }

  Widget termsAndConditionBanner() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(children: [
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
              text: 'If you continue, you are accepting ',
              style: TextStyle(
                color: blackColor,
                fontSize: 12,
              ),
              children: [
                TextSpan(
                    text: 'Terms & Conditions ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(
                  text: 'and \n',
                ),
                TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              ]),
        ),
      ]),
    );
  }

  Widget signInButtons(
      String icon, String text, Color bgColor, BuildContext context) {
    return Card(
        color: bgColor,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 30,
                  margin: const EdgeInsets.only(left: 20),
                  child: Image.asset(
                    icon,
                  )),
              Expanded(
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: (bgColor == whiteColor) ? blackColor : whiteColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
