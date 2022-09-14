import 'package:bechdal_app/constants/colors.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget {
  final bool? centerTitle;
  final Color? iconThemeColor;
  final String? bodyText;
  const CommonAppBar(
      {Key? key, this.centerTitle, this.iconThemeColor, this.bodyText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0,
        centerTitle: centerTitle ?? false,
        iconTheme: IconThemeData(color: iconThemeColor ?? blackColor),
        backgroundColor: whiteColor,
        title: Text(
          bodyText ?? '',
          style: TextStyle(
            color: blackColor,
            fontWeight: FontWeight.normal,
            fontSize: 20,
          ),
        ));
  }
}
