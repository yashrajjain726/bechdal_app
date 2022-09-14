import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'constants/widgets.dart';

String? selectedLocation = '';
bool? serviceEnabled;
LocationPermission? permission;
Future<String?> getLocationAndAddress(context) async {
  Position? position =
      await getCurrentLocation(context, serviceEnabled, permission);
  if (kDebugMode) {
    print('positions are $position');
  }
  selectedLocation = await getFetchedAddress(context, position);
  if (selectedLocation != null) {
    return selectedLocation;
  }
  return null;
}

Future<String?> getFetchedAddress(
    BuildContext context, Position? position) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position!.latitude, position.longitude);
  Placemark place = placemarks[0];
  if (kDebugMode) {
    print(place);
  }
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

Future<String> uploadFile(BuildContext context, String filePath) async {
  String imageName = 'product_images/${DateTime.now().microsecondsSinceEpoch}';
  String downloadUrl = '';
  final file = File(filePath);
  try {
    await FirebaseStorage.instance.ref(imageName).putFile(file);
    downloadUrl =
        await FirebaseStorage.instance.ref(imageName).getDownloadURL();
    print(downloadUrl);
  } on FirebaseException catch (e) {
    customSnackBar(context: context, content: e.code);
  }
  return downloadUrl;
}
