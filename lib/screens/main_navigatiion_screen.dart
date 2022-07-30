import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/screens/chat_screen.dart';
import 'package:bechdal_app/screens/home_screen.dart';
import 'package:bechdal_app/screens/profile_screen.dart';
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
    ProfileScreen()
  ];
  PageController controller = PageController();
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: PageView.builder(
            itemCount: 3,
            controller: controller,
            onPageChanged: (page){
              setState(() {
                _index= page;
              });
            },
            itemBuilder:(context,position){
              return pages[position];
            }),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: whiteColor,
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
                tabBackgroundColor: Colors.grey[100]!,
                color: blackColor,
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.chat,
                    text: 'Chat',
                  ),
                  GButton(
                    icon: Icons.person,
                    text: 'Profile',
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
      )
    ;
  }
}
