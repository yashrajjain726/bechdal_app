import 'package:bechdal_app/components/common_page_widget.dart';
import 'package:bechdal_app/components/custom_icon_button.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions/functions.widgets.dart';
import 'package:bechdal_app/screens/location_screen.dart';
import 'package:bechdal_app/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:open_mail_app/open_mail_app.dart';

class EmailVerifyScreen extends StatefulWidget {
  static const String screenId = 'email_otp_screen';
  const EmailVerifyScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  bool isPinEntered = false;
  String smsCode = "";

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return CommonPageWidget(
      text: '',
      body: otpBodyWidget(context),
      containsAppbar: false,
      centerTitle: true,
    );
  }

  Future<void> validateEmailOtp() async {
    if (kDebugMode) {
      print('sms code is : $smsCode');
    }
  }

  Widget otpBodyWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: 250,
          child: Padding(
            padding: const EdgeInsets.only(top: 100, left: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verify Email',
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Check your email to verify your regsitered email',
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Lottie.asset(
                'assets/lottie/verify_lottie.json',
                width: double.infinity,
                height: 350,
              ),
            ),
            InkWell(
              onTap: () async {
                var result = await OpenMailApp.openMailApp();
                if (!result.didOpen && !result.canOpen) {
                  customSnackBar(
                      context: context, content: 'No mail apps installed');
                } else if (!result.didOpen && result.canOpen) {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return MailAppPickerDialog(
                        mailApps: result.options,
                      );
                    },
                  );
                  Navigator.pushReplacementNamed(
                      context, LocationScreen.screenId);
                }
              },
              child: CustomIconButton(
                  text: 'Verify Email',
                  bgColor: secondaryColor,
                  icon: Icons.verified_user,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15)),
            )
          ]),
        ),
      ],
    );
  }
}
