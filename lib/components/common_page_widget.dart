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
  const CommonPageWidget({
    Key? key,
    required this.text,
    required this.body,
    required this.containsAppbar,
    required this.centerTitle,
    this.bottomNavigation,
    this.appBarHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: containsAppbar
          ? PreferredSize(
              child: const CommonAppBar(),
              preferredSize: Size.fromHeight(appBarHeight ?? 50),
            )
          : null,
      body: Container(
        color: whiteColor,
        child: body,
        width: MediaQuery.of(context).size.width,
      ),
      bottomNavigationBar: (bottomNavigation != null)
          ? Container(color: whiteColor, child: bottomNavigation)
          : null,
    );
  }
}
