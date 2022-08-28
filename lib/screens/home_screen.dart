import 'package:bechdal_app/components/category_widget.dart';
import 'package:bechdal_app/components/location_custom_appbar.dart';
import 'package:bechdal_app/constants/colors.constants.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50), child: LocationCustomBar()),
      body: homeBodyWidget(),
    );
  }

  Widget homeBodyWidget() {
    return Container(
      color: whiteColor,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(children: [
        Container(
          color: whiteColor,
          child: Row(children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      labelText:
                          'Search mobile, cars equipments and many more..',
                      labelStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(Icons.notifications_none),
            const SizedBox(
              width: 10,
            ),
          ]),
        ),
        const SizedBox(
          height: 10,
        ),
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
                    return CarouselSlider.builder(
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
                          fit: BoxFit.contain,
                        );
                      },
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
