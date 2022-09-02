import 'package:bechdal_app/components/common_app_bar.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:flutter/material.dart';

class CommonPageWidget extends StatelessWidget {
  final String text;
  final Widget body;
  final bool containsAppbar;
  final bool centerTitle;
  final Widget? bottomNavigation;
  final double? appBarHeight;
  final Widget? myAppBar;
  const CommonPageWidget(
      {Key? key,
      required this.text,
      required this.body,
      required this.containsAppbar,
      required this.centerTitle,
      this.bottomNavigation,
      this.appBarHeight,
      this.myAppBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: containsAppbar
          ? PreferredSize(
              preferredSize: Size.fromHeight(appBarHeight ?? 50),
              child: myAppBar ?? CommonAppBar(bodyText: text),
            )
          : null,
      body: SafeArea(
        child: Container(
          color: whiteColor,
          width: MediaQuery.of(context).size.width,
          child: body,
        ),
      ),
      bottomNavigationBar: (bottomNavigation != null)
          ? Container(color: whiteColor, child: bottomNavigation)
          : null,
    );
  }
}
