import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions.constants.dart';
import 'package:bechdal_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

class LocationScreen extends StatefulWidget {
  static const String screenId = 'location_screen';
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return appBarWidget(context, '', bodyLocationWidget(context), false,
        bottomNavigation: Container(
          color: whiteColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: FlatButton(onPressed: () {}, child: Text('Skip'))),
                Container(
                    margin: EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        fetchLocationAndAddress(
                          context,
                          selectedLocation,
                          serviceEnabled,
                          permission,
                        );
                      },
                      child: const Text('Grant'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor)),
                    )),
              ],
            ),
          ),
        ));
  }

  Widget bodyLocationWidget(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            child: Lottie.asset(
              'assets/lottie/location_lottie.json',
            ),
            height: 250,
            width: 250,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'To continue, we need to know your sell/buy location so that we can further assist you',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
