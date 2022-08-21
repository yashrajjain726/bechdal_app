import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  DocumentSnapshot? doc;

  String? selectedCategory;
  List<String> downloadUrlList = [];

  getCategory(selectedCategory) {
    this.selectedCategory = selectedCategory;
    notifyListeners();
  }

  getCategorySnapshot(snapshot) {
    doc = snapshot;
    notifyListeners();
  }

  getImageList(url) {
    downloadUrlList.add(url);
    print(downloadUrlList.length);
    notifyListeners();
  }
}