import 'package:bechdal_app/components/large_heading_widget.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions/functions.validation.dart';
import 'package:bechdal_app/constants/functions/functions.widgets.dart';
import 'package:bechdal_app/screens/auth/login_screen.dart';
import 'package:bechdal_app/services/auth_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String screenId = 'reset_password_screen';
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              LargeHeadingWidget(
                heading: 'Forgot Password',
                subHeading: 'Enter yout email to continue your password reset',
                headingTextSize: 35,
                subheadingTextSize: 20,
              ),
              ResetFormWidget(),
            ]),
      ),
    );
  }
}

class ResetFormWidget extends StatefulWidget {
  const ResetFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ResetFormWidget> createState() => _ResetFormWidgetState();
}

class _ResetFormWidgetState extends State<ResetFormWidget> {
  AuthService authService = AuthService();
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    _emailController = TextEditingController();
    super.initState();
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
                  height: 25,
                ),
                roundedButton(
                    context: context,
                    bgColor: primaryColor,
                    text: 'Send Reset Link',
                    textColor: whiteColor,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        FirebaseAuth.instance
                            .sendPasswordResetEmail(
                                email: _emailController.text)
                            .then((value) {
                          customSnackBar(
                              context: context,
                              content: 'Reset email sent to your email');
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.screenId);
                        });
                      }
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
