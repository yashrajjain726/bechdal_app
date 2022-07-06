import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions/functions.widgets.dart';
import 'package:bechdal_app/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  static const String screenId = 'home_screen';
  final String? fetchedLocation;
  const HomeScreen({Key? key, this.fetchedLocation}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  var myMenuItems = <String>[
    'Signout',
  ];
  @override
  Widget build(BuildContext context) {
    return appBarWidgetWithLocationBar(
        context, locationBarWidget(context), homeBodyWidget(), true);
  }

  dynamic locationBarWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.location_solid,
                        size: 12,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        widget.fetchedLocation ?? '',
                        style: TextStyle(
                          color: blackColor,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 12,
                      )
                    ],
                  ),
                )),
            decoration: BoxDecoration(
              border: Border.all(
                color: blackColor,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
          ),
        ),
        PopupMenuButton<String>(
            onSelected: menuItemSelect,
            itemBuilder: (BuildContext context) {
              return myMenuItems.map((String choice) {
                return PopupMenuItem<String>(
                  child: Text(choice),
                  value: choice,
                );
              }).toList();
            })
      ],
    );
  }

  Widget homeBodyWidget() {
    return Container();
  }

  void menuItemSelect(item) async {
    switch (item) {
      case 'Signout':
        try {
          loadingDialogBox(context, 'Signing Out');
          if (!kIsWeb) {
            Navigator.pop(context);
            await googleSignIn.signOut();
          }
          await FirebaseAuth.instance.signOut().then((value) {
            Navigator.pushNamedAndRemoveUntil(
                context, WelcomeScreen.screenId, (route) => false);
          });
        } catch (e) {
          Navigator.pop(context);
          customSnackBar(
            context: context,
            content: 'Error signing out. Try again.',
          );
        }
        break;
    }
  }
}
