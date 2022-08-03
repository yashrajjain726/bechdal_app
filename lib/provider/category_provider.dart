import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier{
  DocumentSnapshot? doc ;
  String? selectedCategory;

  getCategory(selectedCategory){
      this.selectedCategory = selectedCategory;
      notifyListeners();
  }
  getCategorySnapshot(snapshot){
    doc = snapshot;
    notifyListeners();
  }
}