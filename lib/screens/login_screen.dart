import 'package:bechdal_app/components/larget_heading_widget.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions/functions.validation.dart';
import 'package:bechdal_app/constants/functions/functions.widgets.dart';
import 'package:bechdal_app/screens/auth/phone_auth_screen.dart';
import 'package:bechdal_app/screens/auth/reset_password_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              LargeHeadingWidget(
                  heading: 'Welcome', subHeading: 'Sign In to Continue'),
              SignInFormWidget(),
            ]),
      ),
    );
  }
}

class SignInFormWidget extends StatefulWidget {
  const SignInFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInFormWidget> createState() => _SignInFormWidgetState();
}

class _SignInFormWidgetState extends State<SignInFormWidget> {
  AuthService authService = AuthService();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool obsecure = true;

  @override
  void initState() {
    // TODO: implement initState
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    return validateEmail(
                        value, EmailValidator.validate(_emailController.text));
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
                  controller: _passwordController,
                  validator: (value) {
                    return validatePassword(value, _passwordController.text);
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
                      contentPadding: const EdgeInsets.all(20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(
                    top: 10,
                    right: 5,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, ResetPasswordScreen.screenId);
                    },
                    child: Text(
                      'Forgot Password ?',
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                roundedButton(
                    context: context,
                    bgColor: primaryColor,
                    text: 'Sign In',
                    textColor: whiteColor,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await authService.getAdminCredentialEmailAndPassword(
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
        const SizedBox(
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
        const SizedBox(
          height: 20,
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
        SignInButtonWidget(),
      ],
    );
  }
}

class SignInButtonWidget extends StatefulWidget {
  const SignInButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInButtonWidget> createState() => _SignInButtonWidgetState();
}

class _SignInButtonWidgetState extends State<SignInButtonWidget> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: customizableIconButton(
            text: 'Sign In with Phone',
            imageIcon: 'assets/phone.png',
            bgColor: greyColor,
            context: context,
            imageOrIconColor: whiteColor,
            imageOrIconRadius: 20,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        InkWell(
          onTap: () async {
            User? user = await AuthService.signInWithGoogle(context: context);
            if (user != null) {
              authService.getAdminCredentialPhoneNumber(context, user);
            }
          },
          child: customizableIconButton(
              text: 'Sign In with Google',
              imageIcon: 'assets/google.png',
              bgColor: whiteColor,
              context: context),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
