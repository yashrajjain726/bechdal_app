import 'package:bechdal_app/components/category_widget.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/constants/functions/functions.widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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

  Widget homeBodyWidget() {
    return Container(
      color: whiteColor,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Column(children: [
        Column(
          children: [
            FutureBuilder(
              future: downloadBannerImageUrlList(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
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
    );
  }
}
