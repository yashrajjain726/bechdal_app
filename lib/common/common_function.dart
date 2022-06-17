import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:flutter/material.dart';

loadingDialogBox(BuildContext context) {
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
