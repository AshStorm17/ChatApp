import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'group_info.dart';

class GroupChatRoom extends StatelessWidget {
  GroupChatRoom({
    super.key,
    required this.groupName,
    required this.groupChatId,
  });

  final String groupChatId, groupName;

  final TextEditingController message = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void onSendMessage() async {
    if (message.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "sendBy": auth.currentUser!.displayName,
        "message": message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      message.clear();

      await firestore
          .collection('groups')
          .doc(groupChatId)
          .collection('chats')
          .add(chatData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GroupInfo(
                        groupName: groupName,
                        groupId: groupChatId,
                      ))),
              icon: const Icon(Icons.more_vert))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: size.height * 0.75,
              margin: EdgeInsets.symmetric(
                horizontal: size.width * 0.02,
                vertical: size.height * 0.01,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height / 1.25,
                      width: size.width,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: firestore
                            .collection('groups')
                            .doc(groupChatId)
                            .collection('chats')
                            .orderBy('time')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> chatMap =
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>;
                                return Builder(builder: (context) {
                                  if (chatMap['type'] == "text") {
                                    return Container(
                                      width: size.width,
                                      alignment: chatMap['sendby'] ==
                                              auth.currentUser?.displayName
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 14,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: chatMap['sendby'] ==
                                                  auth.currentUser?.displayName
                                              ? Colors.indigo
                                              : Colors.lime,
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              chatMap['sendBy'],
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: size.height / 200,
                                            ),
                                            Text(
                                              chatMap['message'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else if (chatMap['type'] == "notify") {
                                    return Container(
                                      width: size.width,
                                      alignment: Alignment.center,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 8,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.black38,
                                        ),
                                        child: Text(
                                          chatMap['message'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Placeholder();
                                  }
                                });
                              },
                            );
                          } else {
                            return const Placeholder();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.1,
              width: size.width,
              child: Container(
                height: size.height / 10,
                width: size.width,
                alignment: Alignment.center,
                child: SizedBox(
                  height: size.height / 12,
                  width: size.width / 1.1,
                  child: Row(
                    children: [
                      SizedBox(
                        height: size.height / 12,
                        width: size.width / 1.3,
                        child: TextField(
                          controller: message,
                          decoration: InputDecoration(
                            hintText: "Send Message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onSendMessage,
                        icon: const Icon(Icons.send),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
