import 'package:bechdal_app/services/firebase_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  final FirebaseUser _firebaseUser = FirebaseUser();
  DocumentSnapshot? doc;
  DocumentSnapshot<Map<String, dynamic>>? userDetails;

  String? selectedCategory;
  String? selectedSubCategory;
  List<String> imageUploadedUrls = [];
  Map<String, dynamic> formData = {};

  setCategory(selectedCategory) {
    this.selectedCategory = selectedCategory;
    notifyListeners();
  }

  setSubCategory(selectedSubCategory) {
    this.selectedSubCategory = selectedSubCategory;
    notifyListeners();
  }

  setCategorySnapshot(snapshot) {
    doc = snapshot;
    notifyListeners();
  }

  setImageList(url) {
    imageUploadedUrls.add(url);
    print(imageUploadedUrls.length);
    notifyListeners();
  }

  setFormData(data) {
    formData = data;
    notifyListeners();
  }

  getUserDetail() {
    // here we get all user data including the form part
    _firebaseUser.getUserData().then((value) {
      userDetails = value as DocumentSnapshot<Map<String, dynamic>>;
      notifyListeners();
    });
  }

  clearData() {
    imageUploadedUrls = [];
    formData = {};
    notifyListeners();
  }
}
