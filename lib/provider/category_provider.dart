import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  DocumentSnapshot? doc;

  String? selectedCategory;
  List<String> imageUploadedUrls = [];
  Map<String, dynamic> form_data = {};

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
    form_data = data;
    notifyListeners();
  }
}