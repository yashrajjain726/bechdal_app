import 'package:bechdal_app/constants/functions/functions.widgets.dart';
import 'package:bechdal_app/screens/home_screen.dart';
import 'package:bechdal_app/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

Future<String?> getLocationAndAddress(context) async {
  String? selectedLocation = '';
  bool? serviceEnabled;
  LocationPermission? permission;
  Position? position =
      await getCurrentLocation(context, serviceEnabled, permission);
  print('positions are $position');
  selectedLocation = await getFetchedAddress(position);
  if (selectedLocation != null) {
    return selectedLocation;
  }
  return null;
}

Future<String?> getFetchedAddress(Position? position) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position!.latitude, position.longitude);
  Placemark place = placemarks[0];
  print(place);
  return '${place.locality}, ${place.postalCode}';
}

Future<dynamic> getCurrentLocation(context, serviceEnabled, permission) async {
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled!) {
    await Geolocator.openLocationSettings();
    return customSnackBar(
        context: context, content: 'Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return customSnackBar(
          context: context,
          content: 'Please Enable Location Service to continue');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return permission_handler.openAppSettings();
  }
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

checkIfLocationExistsInFirebase() {}
