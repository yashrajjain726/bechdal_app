import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/provider/product_provider.dart';
import 'package:bechdal_app/services/auth_service.dart';
import 'package:bechdal_app/services/firebase_user.dart';
import 'package:bechdal_app/services/search_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainAppBarWithSearch extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const MainAppBarWithSearch({
    required this.controller,
    required this.focusNode,
    Key? key,
  }) : super(key: key);

  @override
  State<MainAppBarWithSearch> createState() => _MainAppBarWithSearchState();
}

class _MainAppBarWithSearchState extends State<MainAppBarWithSearch> {
  static List<Products> products = [];
  AuthService authService = AuthService();
  SearchService searchService = SearchService();
  String address = '';
  FirebaseUser firebaseUser = FirebaseUser();
  DocumentSnapshot? sellerDetails;
  @override
  void initState() {
    authService.products.get().then(((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        products.add(Products(
            document: doc,
            title: doc['title'],
            description: doc['description'],
            category: doc['category'],
            subcategory: doc['subcategory'],
            price: doc['price'],
            postDate: doc['posted_at']));
        getSellerAddress(doc['seller_uid']);
      });
    }));
    super.initState();
  }

  getSellerAddress(selledId) {
    firebaseUser.getSellerData(selledId).then((value) => {
          setState(() {
            address = value['address'];
            sellerDetails = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProductProvider>(context);
    return Container(
      height: 150,
      color: Colors.transparent,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bechdal",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 34,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            onTap: () {
              searchService.search(
                  context: context,
                  products: products,
                  address: address,
                  sellerDetails: sellerDetails,
                  provider: provider);
            },
            controller: widget.controller,
            focusNode: widget.focusNode,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: const Icon(Icons.search),
                labelText: 'Search mobile, cars equipments and many more..',
                labelStyle: const TextStyle(
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50))),
          )
        ],
      ),
    );
  }
}
