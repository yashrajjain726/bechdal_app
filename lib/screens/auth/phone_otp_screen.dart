import 'package:bechdal_app/components/bottom_nav_widget.dart';
import 'package:bechdal_app/constants/colors.dart';
import 'package:bechdal_app/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class PhoneOTPScreen extends StatefulWidget {
  static const String screenId = 'phone_otp_screen';
  final phoneNumber;
  final verificationIdFinal;
  const PhoneOTPScreen(
      {Key? key, required this.phoneNumber, required this.verificationIdFinal})
      : super(key: key);

  @override
  State<PhoneOTPScreen> createState() => _PhoneOTPScreenState();
}

class _PhoneOTPScreenState extends State<PhoneOTPScreen> {
  bool isPinEntered = false;
  String smsCode = "";

  Auth authService = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: blackColor),
          backgroundColor: whiteColor,
          elevation: 0,
          title: Text(
            'Verify Otp',
            style: TextStyle(color: blackColor),
          )),
      body: _body(context),
      bottomNavigationBar: BottomNavigationWidget(
        buttonText: 'Next',
        onPressed: validateOTP,
        validator: isPinEntered,
      ),
    );
  }

  Future<void> validateOTP() async {
    if (kDebugMode) {
      print('sms code is : $smsCode');
    }
    await authService.signInwithPhoneNumber(
        widget.verificationIdFinal, smsCode, context);
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          CircleAvatar(
            radius: 30,
            backgroundColor: whiteColor,
            child: Icon(
              CupertinoIcons.person_alt_circle,
              color: secondaryColor,
              size: 60,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'We have sent a 6-digit confirmation code to',
            style: TextStyle(
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
              style: TextStyle(
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
          Text(
            "Enter 6-digit code",
            style: TextStyle(
              color: greyColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
