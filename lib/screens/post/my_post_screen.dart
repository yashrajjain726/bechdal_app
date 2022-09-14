import 'package:bechdal_app/components/common_page_widget.dart';
import 'package:bechdal_app/components/product_listing_widget.dart';
import 'package:bechdal_app/constants/colors.dart';
import 'package:bechdal_app/screens/product/product_card.dart';
import 'package:bechdal_app/services/auth.dart';
import 'package:bechdal_app/services/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyPostScreen extends StatefulWidget {
  static const screenId = 'my_post_screen';
  const MyPostScreen({Key? key}) : super(key: key);

  @override
  State<MyPostScreen> createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {
  Auth authService = Auth();
  UserService firebaseUser = UserService();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0,
          title: Text(
            'My Posts',
            style: TextStyle(color: blackColor),
          ),
          bottom: TabBar(indicatorColor: secondaryColor, tabs: [
            Tab(
              child: Text(
                'My Posts',
                style: TextStyle(color: blackColor),
              ),
            ),
            Tab(
              child: Text(
                'Favourites',
                style: TextStyle(color: blackColor),
              ),
            ),
          ]),
        ),
        body: bodyWidget(authService: authService, firebaseUser: firebaseUser),
      ),
    );
  }
}

bodyWidget({required Auth authService, required UserService firebaseUser}) {
  final numberFormat = NumberFormat('##,##,##0');
  return TabBarView(children: [
    FutureBuilder<QuerySnapshot>(
        future: authService.products
            .where('seller_uid', isEqualTo: firebaseUser.user!.uid)
            .orderBy('posted_at')
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading products..'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: secondaryColor,
              ),
            );
          }
          if (snapshot.data!.docs.length == 0) {
            return Container(
              height: MediaQuery.of(context).size.height - 50,
              child: const Center(
                child: Text('No Posts Added by you...'),
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 2 / 2,
                        mainAxisExtent: 250,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: snapshot.data!.size,
                      itemBuilder: (BuildContext context, int index) {
                        var data = snapshot.data!.docs[index];
                        var price = int.parse(data['price']);
                        String formattedPrice = numberFormat.format(price);
                        return ProductCard(
                          data: data,
                          formattedPrice: formattedPrice,
                          numberFormat: numberFormat,
                        );
                      }),
                ),
              ],
            ),
          );
        }),
    StreamBuilder<QuerySnapshot>(
        stream: authService.products
            .where('favourites', arrayContains: firebaseUser.user!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading products..'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: secondaryColor,
              ),
            );
          }
          if (snapshot.data!.docs.length == 0) {
            return Center(
              child: Text(
                'No Favourites...',
                style: TextStyle(
                  color: blackColor,
                ),
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 2 / 2,
                        mainAxisExtent: 250,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: snapshot.data!.size,
                      itemBuilder: (BuildContext context, int index) {
                        var data = snapshot.data!.docs[index];
                        var price = int.parse(data['price']);
                        String formattedPrice = numberFormat.format(price);
                        return ProductCard(
                          data: data,
                          formattedPrice: formattedPrice,
                          numberFormat: numberFormat,
                        );
                      }),
                ),
              ],
            ),
          );
        }),
  ]);
}
