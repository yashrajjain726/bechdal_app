import 'package:bechdal_app/services/firebase_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  final FirebaseUser _firebaseUser = FirebaseUser();
  DocumentSnapshot? doc;
  DocumentSnapshot<Map<String, dynamic>>? userDetails;

  String? selectedCategory;
  List<String> imageUploadedUrls = [];
  Map<String, dynamic> formData = {};

  getCategory(selectedCategory) {
    this.selectedCategory = selectedCategory;
    notifyListeners();
  }

  getCategorySnapshot(snapshot) {
    doc = snapshot;
    notifyListeners();
  }

  getImageList(url) {
    imageUploadedUrls.add(url);
    print(imageUploadedUrls.length);
    notifyListeners();
  }

  getFormData(data) {
    formData = data;
    notifyListeners();
  }

  getUserDetail() {
    // here we get all user data including the form part
    _firebaseUser.getUserData().then((value) {
      userDetails = value as DocumentSnapshot<Map<String, dynamic>>?;
      print("printing data ${userDetails!.data()}");

      notifyListeners();
    });
  }
}
