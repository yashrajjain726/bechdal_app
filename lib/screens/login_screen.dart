import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions.constants.dart';
import 'package:bechdal_app/screens/auth/phone_auth_screen.dart';
import 'package:bechdal_app/screens/register_screen.dart';
import 'package:bechdal_app/services/auth_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String screenId = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthService authService = AuthService();
  bool obsecure = true;
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 250,
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
                    padding: EdgeInsets.only(left: 30),
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
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          return validateEmail(value,
                              EmailValidator.validate(_emailController.text));
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
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
                        controller: _passwordController,
                        validator: (value) {
                          return validatePassword(value, _emailController.text);
                        },
                        obscureText: obsecure,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: obsecure ? greyColor : blackColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obsecure = !obsecure;
                                  });
                                }),
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
                      Container(
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.only(
                          top: 10,
                          right: 5,
                        ),
                        child: Text(
                          'Forgot Password ?',
                          style: TextStyle(
                            color: blackColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      roundedButton(
                          context: context,
                          bgColor: primaryColor,
                          text: 'SIGN IN',
                          textColor: whiteColor,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              authService.getAdminCredentialEmailAndPassword(
                                  context: context,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  isLoginUser: true);
                            }
                          }),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, RegisterScreen.screenId);
                        },
                      text: 'Create new account',
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryColor,
                      ),
                    )
                  ],
                  style: TextStyle(
                    fontSize: 14,
                    color: greyColor,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Or',
                style: TextStyle(
                  fontSize: 18,
                  color: greyColor,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Column(
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
                      'SIGN IN WITH PHONE',
                      'assets/phone.png',
                      whiteColor,
                      context,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      User? user =
                          await AuthService.signInWithGoogle(context: context);
                      if (user != null) {
                        authService.getAdminCredentialPhoneNumber(
                            context, user);
                      }
                    },
                    child: signInButtons('SIGN IN WITH GOOGLE',
                        'assets/google.png', whiteColor, context),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
