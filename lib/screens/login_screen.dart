import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100),
                child: Image.asset(
                  'assets/logo_named.png',
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                ),
              ),
              phoneNumberLoginButton(
                  Icons.phone_android_outlined, 'Sign in with Phone Number'),
              SizedBox(
                height: 10,
              ),
              SignInButton(
                Buttons.Google,
                onPressed: () {},
                padding: EdgeInsets.symmetric(horizontal: 50),
              ),
              SizedBox(
                height: 10,
              ),
              SignInButton(
                Buttons.FacebookNew,
                onPressed: () {},
                padding: EdgeInsets.symmetric(horizontal: 50),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'OR',
                style: TextStyle(
                  color: blackColor,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Login with Email',
                style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'If you continue, you are accepting ',
                  style: TextStyle(
                    color: blackColor,
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
        )
      ]),
    );
  }

  Widget phoneNumberLoginButton(IconData icon, String text) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 50),
      elevation: 2,
      child: Container(
        height: 36,
        color: greyColor,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: MaterialButton(
            elevation: 2,
            onPressed: () {},
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone_android_outlined,
                  color: whiteColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
