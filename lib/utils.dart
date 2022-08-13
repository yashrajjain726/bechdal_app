import 'dart:io';

import 'package:bechdal_app/constants/functions/functions.widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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
