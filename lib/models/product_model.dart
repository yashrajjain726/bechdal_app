import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  String? title;
  String? description;
  String? category;
  String? subcategory;
  String? price;
  num? postDate;
  DocumentSnapshot? document;
  Products(
      {this.title,
      this.description,
      this.category,
      this.subcategory,
      this.price,
      this.postDate,
      this.document});
}
