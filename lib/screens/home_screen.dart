import 'package:bechdal_app/components/location_custom_appbar.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String screenId = 'home_screen';
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50), child: LocationCustomBar()),
      body: homeBodyWidget(),
    );
  }

  Widget homeBodyWidget() {
    return Container(
      color: whiteColor,
    );
  }
}
