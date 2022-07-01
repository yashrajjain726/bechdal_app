import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions.constants.dart';
import 'package:bechdal_app/screens/login_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    return appBarWidgetWithLocationBar(
        context, locationBarWidget(context), homeBodyWidget(), true);
  }

  Widget locationBarWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: Container(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.location_solid,
                        size: 12,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        widget.fetchedLocation!,
                        style: TextStyle(
                          color: blackColor,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Icon(
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
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
          ),
        ),
        Text(
          'Bechdal',
          style: TextStyle(color: blackColor, fontSize: 20),
        ),
        InkWell(
          onTap: () async {
            try {
              loadingDialogBox(context, 'Signing Out');
              if (!kIsWeb) {
                Navigator.pop(context);
                await googleSignIn.signOut();
              }
              await FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacementNamed(context, WelcomeScreen.screenId);
              });
              ;
            } catch (e) {
              customSnackBar(
                context: context,
                content: 'Error signing out. Try again.',
              );
            }
          },
          child: Text(
            'Sign Out',
            style: TextStyle(color: blackColor, fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget homeBodyWidget() {
    return Container();
  }
}
