import 'package:bechdal_app/components/large_heading_widget.dart';
import 'package:bechdal_app/constants/colors.dart';
import 'package:bechdal_app/forms/register_form.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const screenId = 'register_screen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: _body(),
    );
  }
}

_body() {
  return SingleChildScrollView(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: LargeHeadingWidget(
          heading: 'Create Account',
          subHeading: 'Enter your Name, Email and Password for sign up.',
          anotherTaglineText: '\nAlready have an account ?',
          anotherTaglineColor: secondaryColor,
          subheadingTextSize: 16,
          taglineNavigation: true,
        ),
      ),
      const RegisterForm(),
    ]),
  );
}
