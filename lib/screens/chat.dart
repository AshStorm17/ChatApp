import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRoom extends StatelessWidget {
  ChatRoom({
    super.key,
    required this.chatRoomId,
    required this.userMap,
  });

  final Map<String, dynamic> userMap;
  final String chatRoomId;
  final TextEditingController message = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void onSendMessage() async {
    if (message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        'sendby': auth.currentUser!.displayName,
        'message': message.text,
        'time': FieldValue.serverTimestamp(),
      };
      await firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);

      message.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(userMap['name']),
        backgroundColor: Theme.of(context).primaryColor,
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
                              .collection('chatroom')
                              .doc(chatRoomId)
                              .collection('chats')
                              .orderBy('time', descending: false)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.data != null) {
                              return ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> map =
                                        snapshot.data?.docs[index].data()
                                            as Map<String, dynamic>;
                                    return Container(
                                      width: size.width,
                                      alignment:
                                          map['sendby'] == userMap['name']
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
                                          color: map['sendby'] ==
                                                  auth.currentUser?.displayName
                                              ? Colors.indigo
                                              : Colors.lime,
                                        ),
                                        child: Text(
                                          map['message'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              return Container();
                            }
                          }),
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
