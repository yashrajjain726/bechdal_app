import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';

String? selectedLocation = '';
bool? serviceEnabled;
LocationPermission? permission;
loadingDialogBox(BuildContext context, String loadingMessage) {
  AlertDialog alert = AlertDialog(
    content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(greyColor),
          ),
          const SizedBox(
            width: 30,
          ),
          Text(
            loadingMessage,
            style: const TextStyle(
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

Widget appBarWidget(
    BuildContext context, String text, Widget body, bool containsAppbar,
    {Widget? bottomNavigation}) {
  return Scaffold(
    appBar: containsAppbar
        ? AppBar(
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: blackColor),
            backgroundColor: whiteColor,
            title: Text(
              text,
              style: const TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ))
        : null,
    body: Container(
      color: whiteColor,
      child: body,
      width: MediaQuery.of(context).size.width,
    ),
    bottomNavigationBar: (bottomNavigation != null) ? bottomNavigation : null,
  );
}

Widget appBarWidgetWithLocationBar(BuildContext context, Widget locationWidget,
    Widget body, bool containsAppbar,
    {Widget? bottomNavigation}) {
  return Scaffold(
    appBar: containsAppbar
        ? AppBar(
            elevation: 0,
            centerTitle: false,
            iconTheme: const IconThemeData(color: blackColor),
            backgroundColor: whiteColor,
            title: locationWidget,
          )
        : null,
    body: Container(
      color: whiteColor,
      child: body,
      width: MediaQuery.of(context).size.width,
    ),
    bottomNavigationBar: (bottomNavigation != null) ? bottomNavigation : null,
  );
}

Widget bottomNavigationWidget(
    bool validator, Function()? onPressed, String buttonText,
    {ProgressDialog? progressDialog}) {
  return SafeArea(
    child: Container(
      color: whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: AbsorbPointer(
          absorbing: !validator,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: validator
                    ? MaterialStateProperty.all(primaryColor)
                    : MaterialStateProperty.all(greyColor)),
            onPressed: onPressed,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void fetchLocationAndAddress(
  context,
  selectedLocation,
  serviceEnabled,
  LocationPermission? permission,
) async {
  Position? position =
      await getCurrentLocation(context, serviceEnabled, permission);
  print('positions are $position');
  selectedLocation = await getFetchedAddress(position);
  if (selectedLocation != null) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (builder) => HomeScreen(
                  fetchedLocation: selectedLocation,
                )));
  }
}

Future<String?> getFetchedAddress(Position position) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  Placemark place = placemarks[0];
  return '${place.subLocality}, ${place.postalCode}';
}

Future<Position> getCurrentLocation(context, serviceEnabled, permission) async {
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled!) {
    await Geolocator.openLocationSettings();
    return loadingDialogBox(context, 'Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return loadingDialogBox(context, 'Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return loadingDialogBox(context,
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}
