import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions.constants.dart';
import 'package:bechdal_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';

class PhoneAuthScreen extends StatefulWidget {
  static const String screenId = 'phone_auth_screen';
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  AuthService authService = AuthService();
  var countryCodeController = TextEditingController(text: '+91');
  var phoneNumberController = TextEditingController();
  String counterText = '0';
  bool validate = false;
  bool isLoading = true;
  String verificationIdFinal = "";

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: whiteColor,
      textColor: blackColor,
      loadingText: 'Verifying details..',
      progressIndicatorColor: blackColor,
    );
    return appBarWidget(
        context, 'Login', loginViaPhoneWidget(context), true, true,
        bottomNavigation: bottomNavigationWidget(
            validate, signInValidate, 'Next',
            progressDialog: progressDialog));
  }

  void signInValidate() {
    String number =
        '${countryCodeController.text}${phoneNumberController.text}';
    loadingDialogBox(context, 'Please wait');
    print(number);
    authService.verifyPhoneNumber(context, number);
  }

  Widget loginViaPhoneWidget(BuildContext context) {
    return Padding(
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
            height: 12,
          ),
          Text(
            'Enter your Phone Number',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'We will send confitmation code to your phone number',
            style: TextStyle(
              color: greyColor,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: countryCodeController,
                    decoration: InputDecoration(
                        labelText: 'Country',
                        enabled: false,
                        contentPadding: EdgeInsets.all(20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  )),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      autofocus: true,
                      maxLength: 10,
                      onChanged: (value) {
                        setState(() {
                          counterText = value.length.toString();
                        });
                        if (value.length == 10) {
                          setState(() {
                            validate = true;
                          });
                        }
                        if (value.length < 10) {
                          setState(() {
                            validate = false;
                          });
                        }
                      },
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          counterText: '$counterText/10',
                          counterStyle: TextStyle(fontSize: 10),
                          labelText: 'Phone Number',
                          hintText: 'Enter Your Phone Number',
                          hintStyle: TextStyle(
                            color: greyColor,
                            fontSize: 12,
                          ),
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
