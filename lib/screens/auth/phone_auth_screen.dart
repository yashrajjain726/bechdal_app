import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  var countryCodeController = TextEditingController(text: '+91');
  var phoneNumberController = TextEditingController();
  String counterText = '0';
  bool validate = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: blackColor),
          backgroundColor: whiteColor,
          title: Text(
            'Login',
            style: TextStyle(
              color: blackColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )),
      body: loginViaPhoneWidget(context),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget bottomNavigationBar() {
    return SafeArea(
      child: Container(
        color: whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: AbsorbPointer(
            absorbing: !validate,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: (validate)
                      ? MaterialStateProperty.all(
                          Theme.of(context).primaryColor)
                      : MaterialStateProperty.all(greyColor)),
              onPressed: () {
                String number =
                    '${countryCodeController.text}${phoneNumberController.text}';
                alertDialogBox(context);
                authenticateNumber(number);
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

  Widget loginViaPhoneWidget(BuildContext context) {
    return Container(
      color: whiteColor,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );
  }

  void alertDialogBox(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(greyColor),
            ),
            SizedBox(
              width: 30,
            ),
            Text(
              'Please wait',
              style: TextStyle(
                color: blackColor,
              ),
            )
          ]),
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void authenticateNumber(String number) {}
}
