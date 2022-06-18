// ignore_for_file: unnecessary_const

import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions.constants.dart';
import 'package:bechdal_app/services/phone_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class OTPScreen extends StatefulWidget {
  static const String screenId = 'otp_screen';
  final phoneNumber;
  final verificationIdFinal;
  const OTPScreen(
      {Key? key, required this.phoneNumber, required this.verificationIdFinal})
      : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool isPinEntered = false;
  String smsCode = "";

  PhoneAuthService phoneAuthService = PhoneAuthService();
  @override
  Widget build(BuildContext context) {
    return appBarWidget('Verify OTP', otpBodyWidget(context),
        bottomNavigation:
            bottomNavigationWidget(isPinEntered, validateOTP, 'Next'));
  }

  Future<void> validateOTP() async {
    await phoneAuthService.signInwithPhoneNumber(
        widget.verificationIdFinal, smsCode, context);
  }

  Widget otpBodyWidget(BuildContext context) {
    return Container(
      color: whiteColor,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            const CircleAvatar(
              radius: 30,
              backgroundColor: whiteColor,
              child: const Icon(
                CupertinoIcons.person_alt_circle,
                color: primaryColor,
                size: 60,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'We have sent a 6-digit confirmation code to',
              style: const TextStyle(
                color: blackColor,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                widget.phoneNumber,
                style: const TextStyle(
                  color: blackColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.edit,
                    size: 18,
                  ))
            ]),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: OTPTextField(
                  length: 6,
                  width: MediaQuery.of(context).size.width,
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldWidth: 45,
                  fieldStyle: FieldStyle.box,
                  outlineBorderRadius: 15,
                  style: const TextStyle(fontSize: 17),
                  onChanged: (value) {
                    if (value.length < 6) {
                      setState(() {
                        isPinEntered = false;
                      });
                    }
                  },
                  onCompleted: (pin) {
                    print("Completed: " + pin);
                    setState(() {
                      smsCode = pin;
                      isPinEntered = true;
                    });
                  }),
            ),
            const SizedBox(
              height: 0,
            ),
            const Text(
              "Enter 6-digit code",
              style: const TextStyle(
                color: greyColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
