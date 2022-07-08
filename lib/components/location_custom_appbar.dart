import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions/functions.permission.dart';
import 'package:bechdal_app/constants/functions/functions.widgets.dart';
import 'package:bechdal_app/screens/location_screen.dart';
import 'package:bechdal_app/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LocationCustomBar extends StatefulWidget {
  const LocationCustomBar({Key? key}) : super(key: key);

  @override
  State<LocationCustomBar> createState() => _LocationCustomBarState();
}

class _LocationCustomBarState extends State<LocationCustomBar> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  var myMenuItems = <String>[
    'Signout',
  ];
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    User? user = FirebaseAuth.instance.currentUser;
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(user!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return customSnackBar(
              context: context, content: "Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return customSnackBar(
              context: context, content: "Addrress not selected");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          if (data['address'] == null) {
            if (data['state'] == null) {
              Position? position = data['location'];
              print('location from 51 is $position ');
              getFetchedAddress(context, position).then((location) {
                print('location from 52 is $location');
                return locationBarWidget(context, location);
              });
            }
          } else {
            print('location from 57 is ${data['address']}');
            return locationBarWidget(context, data['address']);
          }
          print('location from 60');
          return locationBarWidget(context, 'Update Location');
        }
        print('location from end');
        return locationBarWidget(context, 'Fetching location');
      },
    );
  }

  Widget locationBarWidget(BuildContext context, String? location) {
    return AppBar(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(color: blackColor),
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, LocationScreen.screenId);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      CupertinoIcons.location_solid,
                      size: 12,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      location ?? '',
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_outlined,
                      size: 12,
                    )
                  ],
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
        ),
      ),
    );
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
