import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/screens/auth/phone_auth_screen.dart';
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
    return Scaffold(
        bottomNavigationBar: bottomNavigationWidget(),
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: blackColor),
            backgroundColor: whiteColor,
            title: Text(
              'Verify OTP',
              style: TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )),
        body: Container(
          color: whiteColor,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: whiteColor,
                  child: Icon(
                    CupertinoIcons.person_alt_circle,
                    color: primaryColor,
                    size: 60,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'We have sent a 6-digit confirmation code to',
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
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
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.edit,
                        size: 18,
                      ))
                ]),
                SizedBox(
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
                      style: TextStyle(fontSize: 17),
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
                SizedBox(
                  height: 0,
                ),
                Text(
                  "Enter 6-digit code",
                  style: TextStyle(
                    color: greyColor,
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: "Did't receive the verification OTP?",
                    style: TextStyle(
                      fontSize: 14,
                      color: blackColor,
                    ),
                  ),
                  TextSpan(
                      text: " Resend again",
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryColor,
                      )),
                ])),
              ],
            ),
          ),
        ));
  }

  Widget bottomNavigationWidget() {
    return SafeArea(
      child: Container(
        color: whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: AbsorbPointer(
            absorbing: !isPinEntered,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: isPinEntered
                      ? MaterialStateProperty.all(primaryColor)
                      : MaterialStateProperty.all(greyColor)),
              onPressed: () async {
                await phoneAuthService.signInwithPhoneNumber(
                    widget.verificationIdFinal, smsCode, context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
