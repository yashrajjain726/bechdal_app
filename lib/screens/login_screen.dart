import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions.constants.dart';
import 'package:bechdal_app/screens/auth/phone_auth_screen.dart';
import 'package:bechdal_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  static const String screenId = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2 - 150,
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      'Sign In to Continue!',
                      style: TextStyle(
                        color: greyColor,
                        fontSize: 25,
                      ),
                    ),
                  )
                ],
              ),
            )),
        Expanded(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        onChanged: (value) {},
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            filled: true,
                            labelText: 'Email',
                            hintText: 'Enter your Email',
                            hintStyle: TextStyle(
                              color: greyColor,
                              fontSize: 12,
                            ),
                            contentPadding: EdgeInsets.all(20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8))),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        autofocus: true,
                        onChanged: (value) {},
                        obscureText: true,
                        decoration: InputDecoration(
                            filled: true,
                            labelText: 'Password',
                            hintText: 'Enter Your Password',
                            hintStyle: TextStyle(
                              color: greyColor,
                              fontSize: 12,
                            ),
                            contentPadding: EdgeInsets.all(20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8))),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      roundedButton(
                          context: context,
                          bgColor: primaryColor,
                          text: 'SIGN IN',
                          textColor: whiteColor,
                          onPressed: () {}),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const PhoneAuthScreen()));
                      },
                      child: signInButtons(
                          'assets/phone.png', whiteColor, context),
                    ),
                    InkWell(
                      onTap: () async {
                        User? user = await AuthService.signInWithGoogle(
                            context: context);
                        if (user != null) {
                          authService.addUser(context, user);
                        }
                      },
                      child: signInButtons(
                          'assets/google.png', whiteColor, context),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget signInButtons(String icon, Color bgColor, BuildContext context) {
    return Card(
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle),
            margin: const EdgeInsets.all(10),
            height: 20,
            child: Image.asset(
              icon,
            )));
  }
}
