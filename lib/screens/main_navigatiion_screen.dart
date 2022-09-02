import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/main.dart';
import 'package:bechdal_app/screens/chat_screen.dart';
import 'package:bechdal_app/screens/home_screen.dart';
import 'package:bechdal_app/screens/post/add_post_screen.dart';
import 'package:bechdal_app/screens/post/my_post_screen.dart';
import 'package:bechdal_app/screens/profile_screen.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      extendBody: true,
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
          boxShadow: [
            BoxShadow(
              color: blackColor,
              offset: Offset(0, 45),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
        child: DotNavigationBar(
          backgroundColor: Colors.transparent,
          margin: EdgeInsets.zero,
          paddingR: EdgeInsets.zero,
          selectedItemColor: secondaryColor,
          currentIndex: _index,
          dotIndicatorColor: Colors.transparent,
          unselectedItemColor: disabledColor,
          enablePaddingAnimation: false,
          enableFloatingNavBar: false,
          onTap: (index) {
            setState(() {
              _index = index;
            });
            controller.jumpToPage(index);
          },
          items: [
            DotNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                    color: _index == 0 ? whiteColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(40)),
                child: Icon(
                  Icons.home,
                  color: _index == 0 ? secondaryColor : disabledColor,
                ),
                padding: EdgeInsets.all(10),
              ),
            ),
            DotNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                    color: _index == 1 ? whiteColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(40)),
                child: Icon(
                  Icons.chat,
                  color: _index == 1 ? secondaryColor : disabledColor,
                ),
                padding: EdgeInsets.all(10),
              ),
            ),
            DotNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                    color: _index == 2 ? whiteColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(40)),
                child: Icon(
                  Icons.add,
                  color: _index == 2 ? secondaryColor : disabledColor,
                ),
                padding: EdgeInsets.all(10),
              ),
            ),
            DotNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                    color: _index == 3 ? whiteColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(40)),
                child: Icon(
                  CupertinoIcons.heart,
                  color: _index == 3 ? secondaryColor : disabledColor,
                ),
                padding: EdgeInsets.all(10),
              ),
            ),
            DotNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                    color: _index == 4 ? whiteColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(40)),
                child: Icon(
                  Icons.person,
                  color: _index == 4 ? secondaryColor : disabledColor,
                ),
                padding: EdgeInsets.all(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
