import 'dart:ui';

import 'package:bechdal_app/components/category_widget.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions/functions.permission.dart';
import 'package:bechdal_app/constants/functions/functions.widgets.dart';
import 'package:bechdal_app/screens/location_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  static const String screenId = 'home_screen';
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController searchController;
  late FocusNode searchNode;
  Future<List<String>> downloadBannerImageUrlList() async {
    List<String> bannerUrlList = [];
    final ListResult storageRef =
        await FirebaseStorage.instance.ref().child('banner').listAll();
    List<Reference> bannerRef = storageRef.items;
    await Future.forEach<Reference>(bannerRef, (image) async {
      final String fileUrl = await image.getDownloadURL();
      bannerUrlList.add(fileUrl);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var imageUrl in bannerUrlList) {
        precacheImage(NetworkImage(imageUrl), context);
      }
    });
    return bannerUrlList;
  }

  @override
  void initState() {
    searchController = TextEditingController();
    searchNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          customHomeAppBar(controller: searchController, focusNode: searchNode),
      body: homeBodyWidget(),
    );
  }

  lcoationAutoFetchBar(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    User? user = FirebaseAuth.instance.currentUser;
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(user!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return customSnackBar(
              context: context, content: "Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return customSnackBar(
              context: context, content: "Addrress not selected");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          if (data['address'] == null) {
            Position? position = data['location'];
            getFetchedAddress(context, position).then((location) {
              return locationTextWidget(
                location: location,
              );
            });
          } else {
            return locationTextWidget(location: data['address']);
          }
          return locationTextWidget(location: 'Update Location');
        }
        return locationTextWidget(location: 'Fetching location');
      },
    );
  }

  Widget homeBodyWidget() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          color: disabledColor,
          width: double.infinity,
          height: 35,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(LocationScreen.screenId);
            },
            child: Center(child: lcoationAutoFetchBar(context)),
          ),
        ),
        Container(
          color: whiteColor,
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          child: Column(children: [
            Column(
              children: [
                FutureBuilder(
                  future: downloadBannerImageUrlList(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: 200,
                      );
                    } else {
                      if (snapshot.hasError) {
                        return const Text(
                            'Currently facing issue in banner loading');
                      } else {
                        return Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            CarouselSlider.builder(
                              itemCount: snapshot.data!.length,
                              options: CarouselOptions(
                                viewportFraction: 1,
                                autoPlay: true,
                                enlargeCenterPage: true,
                              ),
                              itemBuilder: (context, index, realIdx) {
                                return Image.network(
                                  snapshot.data![index],
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                );
                              },
                            )
                          ],
                        );
                      }
                    }
                  },
                ),
                const CategoryWidget()
              ],
            )
          ]),
        ),
      ],
    );
  }
}

class locationTextWidget extends StatelessWidget {
  final String? location;
  const locationTextWidget({Key? key, required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.pin_drop,
          size: 18,
        ),
        Text(
          location ?? '',
          style: TextStyle(
            color: blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
