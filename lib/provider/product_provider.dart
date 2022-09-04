import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  DocumentSnapshot? productData;
  DocumentSnapshot? sellerDetails;
  setProductDetails(details) {
    productData = details;
    notifyListeners();
  }

  setSellerDetails(details) {
    sellerDetails = details;
    notifyListeners();
  }
}
