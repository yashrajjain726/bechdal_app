import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/screens/category/category_list_screen.dart';
import 'package:bechdal_app/screens/chat/chat_card.dart';
import 'package:bechdal_app/screens/main_navigatiion_screen.dart';
import 'package:bechdal_app/services/auth.dart';
import 'package:bechdal_app/services/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const screenId = 'chat_screen';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Auth authService = Auth();
  UserService firebaseUser = UserService();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: whiteColor,
          title: Text(
            'Chats',
            style: TextStyle(
              color: blackColor,
            ),
          ),
          bottom: TabBar(
              labelStyle: TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'Oswald',
              ),
              labelColor: blackColor,
              indicatorColor: secondaryColor,
              tabs: [
                const Tab(
                  text: 'All',
                ),
                const Tab(
                  text: 'Buying',
                ),
                const Tab(
                  text: 'Selling',
                )
              ]),
        ),
        body: TabBarView(
          children: [
            Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: authService.messages
                      .where('users', arrayContains: firebaseUser.user!.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading chats..'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: secondaryColor),
                      );
                    }
                    if (snapshot.data!.docs.length == 0) {
                      return Center(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Ahhh! Start Selling/Buying...'),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(blackColor)),
                              onPressed: () => Navigator.of(context)
                                  .pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (c) =>
                                              const MainNavigationScreen()),
                                      (route) => false),
                              child: const Text('Recommended Products'))
                        ],
                      ));
                    }
                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return ChatCard(data: data);
                      }).toList(),
                    );
                  }),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: authService.messages
                      .where('users', arrayContains: firebaseUser.user!.uid)
                      .where('product.seller',
                          isNotEqualTo: firebaseUser.user!.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading chats..'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: secondaryColor),
                      );
                    }
                    if (snapshot.data!.docs.length == 0) {
                      return Center(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                              'Wanna buy great products, here are some...'),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(blackColor)),
                              onPressed: () => Navigator.of(context)
                                  .pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (c) =>
                                              const MainNavigationScreen()),
                                      (route) => false),
                              child: const Text('See Latest Products'))
                        ],
                      ));
                    }
                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return ChatCard(data: data);
                      }).toList(),
                    );
                  }),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: authService.messages
                      .where('users', arrayContains: firebaseUser.user!.uid)
                      .where('product.seller',
                          isEqualTo: firebaseUser.user!.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading chats..'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: secondaryColor),
                      );
                    }
                    if (snapshot.data!.docs.length == 0) {
                      return Center(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('No chats yet ? Start Now !'),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(blackColor)),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          const CategoryListScreen(
                                            isForForm: true,
                                          ))),
                              child: const Text('Add Products'))
                        ],
                      ));
                    }
                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return ChatCard(data: data);
                      }).toList(),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
