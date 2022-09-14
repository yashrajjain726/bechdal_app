import 'package:bechdal_app/constants/colors.dart';
import 'package:bechdal_app/constants/validators.dart';
import 'package:bechdal_app/services/auth.dart';
import 'package:bechdal_app/services/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:intl/intl.dart';

class ChatStream extends StatefulWidget {
  final String? chatroomId;
  const ChatStream({Key? key, this.chatroomId}) : super(key: key);

  @override
  State<ChatStream> createState() => _ChatStreamState();
}

class _ChatStreamState extends State<ChatStream> {
  Stream<QuerySnapshot>? changeMessageStream;
  DocumentSnapshot? chatDocument;
  Auth authService = Auth();
  UserService firebaseUser = UserService();
  @override
  void initState() {
    super.initState();
    firebaseUser.getChatDetails(chatroomId: widget.chatroomId).then((value) {
      setState(() {
        changeMessageStream = value;
      });
    });
    authService.messages.doc(widget.chatroomId).get().then((value) {
      setState(() {
        chatDocument = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      child: StreamBuilder<QuerySnapshot>(
          stream: changeMessageStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Fetching error..'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: secondaryColor),
              );
            }
            return snapshot.hasData
                ? Column(
                    children: [
                      if (chatDocument != null)
                        ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: disabledColor.withOpacity(0.2),
                            child: Image.network(
                              chatDocument!['product']['product_img'],
                              height: 30,
                              width: 30,
                            ),
                          ),
                          title: Text(chatDocument!['product']['title']),
                          trailing: Text(
                              '\u{20B9} ${(intToStringFormatter(chatDocument!['product']['price']))}'),
                        ),
                      Expanded(
                        child: Container(
                          color: disabledColor.withOpacity(0.2),
                          child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                String sentBy =
                                    snapshot.data!.docs[index]['sent_by'];
                                String myId = firebaseUser.user!.uid;
                                String lastChatDate;
                                var date = formattedTime(
                                    snapshot.data!.docs[index]['time']);
                                var today = DateFormat.yMMMd().format(
                                    DateTime.fromMicrosecondsSinceEpoch(
                                        DateTime.now().microsecondsSinceEpoch));
                                if (date == today) {
                                  lastChatDate = DateFormat('hh:mm').format(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          snapshot.data!.docs[index]['time']));
                                } else {
                                  lastChatDate = date.toString();
                                }
                                return Column(
                                  children: [
                                    ChatBubble(
                                        clipper: sentBy == myId
                                            ? ChatBubbleClipper5(
                                                type: BubbleType.sendBubble,
                                              )
                                            : ChatBubbleClipper5(
                                                type:
                                                    BubbleType.receiverBubble),
                                        alignment: sentBy == myId
                                            ? Alignment.topRight
                                            : Alignment.topLeft,
                                        margin: const EdgeInsets.only(
                                            top: 20, right: 10),
                                        backGroundColor: sentBy == myId
                                            ? blackColor
                                            : whiteColor,
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                          ),
                                          child: Text(
                                            snapshot.data!.docs[index]
                                                ['message'],
                                            style: TextStyle(
                                              color: sentBy == myId
                                                  ? whiteColor
                                                  : blackColor,
                                            ),
                                          ),
                                        )),
                                    Align(
                                        alignment: sentBy == myId
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                            margin: sentBy == myId
                                                ? const EdgeInsets.only(
                                                    right: 10)
                                                : const EdgeInsets.only(
                                                    left: 10),
                                            child: Text(lastChatDate)))
                                  ],
                                );
                              }),
                        ),
                      )
                    ],
                  )
                : Container();
          }),
    );
  }
}
