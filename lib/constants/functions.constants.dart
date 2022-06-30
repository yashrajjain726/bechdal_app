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

Widget appBarWidget(BuildContext context, String text, Widget body,
    bool containsAppbar, bool centerTitle,
    {Widget? bottomNavigation}) {
  return Scaffold(
    appBar: containsAppbar
        ? AppBar(
            elevation: 0,
            centerTitle: centerTitle,
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
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: AbsorbPointer(
          absorbing: !validator,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: validator
                    ? MaterialStateProperty.all(primaryColor)
                    : MaterialStateProperty.all(greyColor)),
            onPressed: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
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
    context, selectedLocation, serviceEnabled, LocationPermission? permission,
    {Widget? navigateTo}) async {
  Position? position =
      await getCurrentLocation(context, serviceEnabled, permission);
  print('positions are $position');
  selectedLocation = await getFetchedAddress(position);
  if (selectedLocation != null) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (builder) =>
                navigateTo ??
                HomeScreen(
                  fetchedLocation: selectedLocation,
                )));
  }
}

Future<String?> getFetchedAddress(Position? position) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position!.latitude, position.longitude);
  Placemark place = placemarks[0];
  return '${place.subLocality}, ${place.postalCode}';
}

Future<dynamic> getCurrentLocation(context, serviceEnabled, permission) async {
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled!) {
    await Geolocator.openLocationSettings();
    return customSnackBar(content: 'Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return customSnackBar(content: 'Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return customSnackBar(
        content:
            'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

SnackBar customSnackBar({required String content}) {
  return SnackBar(
    backgroundColor: blackColor,
    content: Text(
      content,
      style: TextStyle(color: whiteColor, letterSpacing: 0.5),
    ),
  );
}

Widget roundedButton({
  context,
  Color? bgColor,
  Function()? onPressed,
  Color? textColor,
  String? text,
  Color? borderColor,
}) {
  return Container(
    width: double.infinity,
    child: ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(
                color: borderColor ?? primaryColor,
              ),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(bgColor)),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Text(
          text!,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    ),
  );
}
