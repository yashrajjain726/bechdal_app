import 'package:bechdal_app/components/custom_icon_button.dart';
import 'package:bechdal_app/constants/colors.dart';
import 'package:bechdal_app/screens/auth/phone_auth_screen.dart';
import 'package:bechdal_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginInButtons extends StatefulWidget {
  const LoginInButtons({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginInButtons> createState() => _LoginInButtonsState();
}

class _LoginInButtonsState extends State<LoginInButtons> {
  Auth authService = Auth();
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
          child: CustomIconButton(
            text: 'Sign In with Phone',
            imageIcon: 'assets/phone.png',
            bgColor: greyColor,
            imageOrIconColor: whiteColor,
            imageOrIconRadius: 20,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        InkWell(
          onTap: () async {
            User? user = await Auth.signInWithGoogle(context: context);
            if (user != null) {
              authService.getAdminCredentialPhoneNumber(context, user);
            }
          },
          child: CustomIconButton(
            text: 'Sign In with Google',
            imageIcon: 'assets/google.png',
            bgColor: whiteColor,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
