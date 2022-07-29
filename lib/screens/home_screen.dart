import 'package:bechdal_app/components/banner_widget.dart';
import 'package:bechdal_app/components/category_widget.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(children: [
        Container(
          color: whiteColor,
          child: Row(children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      labelText:
                          'Search mobile, cars equipments and many more..',
                      labelStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(Icons.notifications_none),
            const SizedBox(
              width: 10,
            ),
          ]),
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: [
            BannerWidget(
              tagLines: const [
                'Buy your needs in seconds\nBy showing interests ',
                'Sell your un-needs in seconds.',
                'Connect with your buy/sell customer in seconds via\nchat and calls '
              ],
              bannerImage:
                  'https://firebasestorage.googleapis.com/v0/b/bechdal-app.appspot.com/o/banner%2Fcar_banner_logo.png?alt=media&token=a5dcf75e-b3e6-4c0d-b538-c05592a2acb2',
              bannerColor: bannerPastleOne,
              buttonTextOne: 'Buy Cars',
              buttonTextTwo: 'Sell Cars',
              heading: 'Cars',
            ),
            CategoryWidget()
          ],
        )
      ]),
    );
  }
}
