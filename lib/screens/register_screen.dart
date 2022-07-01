import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions.constants.dart';
import 'package:bechdal_app/screens/auth/phone_auth_screen.dart';
import 'package:bechdal_app/screens/login_screen.dart';
import 'package:bechdal_app/services/auth_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const screenId = 'register_screen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthService authService = AuthService();
  bool obsecure = true;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    _firstNameController.dispose();
    _lastNameController.dispose();
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
              width: double.infinity,
              height: 250,
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                            color: blackColor,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: RichText(
                        text: TextSpan(
                            text:
                                'Enter your Name, Email and Password for sign up.',
                            style: TextStyle(
                              color: greyColor,
                              fontSize: 17,
                            ),
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacementNamed(
                                        context, LoginScreen.screenId);
                                  },
                                text: ' Already have account ?',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 17,
                                ),
                              )
                            ]),
                      ),
                    )
                  ],
                ),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height - 250,
            child: Column(
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
                          validator: (value) {
                            return validateName(value, 'first');
                          },
                          controller: _firstNameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              labelText: 'First Name',
                              hintText: 'Enter your First Name',
                              hintStyle: TextStyle(
                                color: greyColor,
                                fontSize: 12,
                              ),
                              contentPadding: const EdgeInsets.all(20),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          validator: (value) {
                            return validateName(value, 'last');
                          },
                          controller: _lastNameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              labelText: 'Last Name',
                              hintText: 'Enter your Last Name',
                              hintStyle: TextStyle(
                                color: greyColor,
                                fontSize: 12,
                              ),
                              contentPadding: const EdgeInsets.all(20),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
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
                              contentPadding: const EdgeInsets.all(20),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          obscureText: obsecure,
                          controller: _passwordController,
                          validator: (value) {
                            return validatePassword(
                                value, _emailController.text);
                          },
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
                              contentPadding: const EdgeInsets.all(20),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        roundedButton(
                            context: context,
                            bgColor: primaryColor,
                            text: 'SIGN UP',
                            textColor: whiteColor,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                authService.getAdminCredentialEmailAndPassword(
                                    context: context,
                                    firstName: _firstNameController.text,
                                    lastName: _lastNameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    isLoginUser: false);
                              }
                            }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: Text(
                    'By Signing up you agree to our Terms and Conditions, and Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: greyColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Or',
                  style: TextStyle(
                    fontSize: 18,
                    color: greyColor,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => PhoneAuthScreen(
                                      isFromLogin: false,
                                    )));
                      },
                      child: signInButtons('SIGN UP WITH PHONE',
                          'assets/phone.png', whiteColor, context),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        User? user = await AuthService.signInWithGoogle(
                            context: context);
                        if (user != null) {
                          authService.getAdminCredentialPhoneNumber(
                              context, user);
                        }
                      },
                      child: signInButtons('SIGN UP WITH GOOGLE',
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
        ]),
      ),
    );
  }
}
