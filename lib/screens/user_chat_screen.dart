import 'package:bechdal_app/constants/colors.constants.dart';
import 'package:bechdal_app/provider/product_provider.dart';
import 'package:bechdal_app/services/firebase_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserChatScreen extends StatefulWidget {
  static const String screenId = 'user_chat_screen';
  final String? chatroomId;
  const UserChatScreen({Key? key, this.chatroomId}) : super(key: key);

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  Stream<QuerySnapshot>? changeMessageStream;
  late TextEditingController msgController;
  FirebaseUser firebaseUser = FirebaseUser();

  bool send = false;

  @override
  void initState() {
    super.initState();
    firebaseUser.getChatDetails(chatroomId: widget.chatroomId).then((value) {
      setState(() {
        changeMessageStream = value;
      });
    });
    msgController = TextEditingController();
  }

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  sendMessage() {
    if (msgController.text.isNotEmpty) {
      Map<String, dynamic> message = {
        'message': msgController.text,
        'sent_by': firebaseUser.user!.uid,
        'time': DateTime.now().microsecondsSinceEpoch,
      };

      firebaseUser.createChat(chatroomId: widget.chatroomId, message: message);
      msgController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0,
          iconTheme: IconThemeData(color: blackColor),
          title: Text(
            '${productProvider.sellerDetails!['name']} (${productProvider.productData!['title']})',
            style: TextStyle(color: blackColor),
          ),
        ),
        body: Container(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: changeMessageStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Fetching error..'),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child:
                              CircularProgressIndicator(color: secondaryColor),
                        );
                      }
                      return snapshot.hasData
                          ? ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Text(
                                  snapshot.data!.docs[index]['message'],
                                  style: TextStyle(
                                    color: blackColor,
                                  ),
                                );
                              })
                          : Container();
                    }),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: disabledColor.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  send = true;
                                });
                              } else {
                                setState(() {
                                  send = false;
                                });
                              }
                            },
                            controller: msgController,
                            style: TextStyle(
                              color: secondaryColor,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter you message...',
                              hintStyle: TextStyle(
                                color: blackColor,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.attach_file),
                        ),
                        Visibility(
                          visible: send,
                          child: IconButton(
                            onPressed: sendMessage,
                            icon: Icon(Icons.send),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
