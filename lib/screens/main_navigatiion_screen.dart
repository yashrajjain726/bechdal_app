import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/main.dart';
import 'package:bechdal_app/screens/chat_screen.dart';
import 'package:bechdal_app/screens/home_screen.dart';
import 'package:bechdal_app/screens/post/add_post_screen.dart';
import 'package:bechdal_app/screens/post/my_post_screen.dart';
import 'package:bechdal_app/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  static const screenId = 'main_nav_screen';
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  List pages = [
    HomeScreen(),
    ChatScreen(),
    AddPostScreen(),
    MyPostScreen(),
    ProfileScreen(),
  ];
  PageController controller = PageController();
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          itemCount: pages.length,
          controller: controller,
          onPageChanged: (page) {
            setState(() {
              _index = page;
            });
          },
          itemBuilder: (context, position) {
            return pages[position];
          }),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: blackColor,
          // boxShadow: [
          //   BoxShadow(
          //     blurRadius: 20,
          //     color: blackColor.withOpacity(.1),
          //   )
          // ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(

              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: primaryColor,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: whiteColor,
              color: whiteColor,
              tabs: [
                GButton(
                  icon: Icons.home,
                ),
                GButton(
                  icon: Icons.chat,
                ),
                GButton(
                  icon: Icons.add,
                ),
                GButton(
                  icon: CupertinoIcons.heart,
                ),
                GButton(
                  icon: Icons.person,
                ),
              ],
              selectedIndex: _index,
              onTabChange: (index) {
                setState(() {
                  _index = index;
                });
                controller.jumpToPage(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
