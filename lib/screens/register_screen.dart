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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              width: double.infinity,
              height: 250,
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
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
                            style: const TextStyle(
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
                                style: const TextStyle(
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
          Container(
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
                              filled: true,
                              labelText: 'First Name',
                              hintText: 'Enter your First Name',
                              hintStyle: const TextStyle(
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
                              filled: true,
                              labelText: 'Last Name',
                              hintText: 'Enter your Last Name',
                              hintStyle: const TextStyle(
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
                              filled: true,
                              labelText: 'Email',
                              hintText: 'Enter your Email',
                              hintStyle: const TextStyle(
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
                              filled: true,
                              labelText: 'Password',
                              hintText: 'Enter Your Password',
                              hintStyle: const TextStyle(
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
                                loadingDialogBox(
                                    context, 'Validating Details..');
                                authService
                                    .getAdminCredentialEmailAndPassword(
                                        context: context,
                                        firstName: _firstNameController.text,
                                        lastName: _lastNameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        isLoginUser: false)
                                    .then((value) {
                                  Navigator.pop(context);
                                  customSnackBar(
                                      context: context,
                                      content: 'Registered successfully');
                                  Navigator.pushReplacementNamed(
                                      context, LoginScreen.screenId);
                                });
                              }
                            }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: const Text(
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
                const Text(
                  'Or',
                  style: TextStyle(
                    fontSize: 18,
                    color: greyColor,
                  ),
                ),
                const SizedBox(
                  height: 15,
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
                          authService.getAdminCredentialPhoneNumber(
                              context, user);
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
        ]),
      ),
    );
  }
}
