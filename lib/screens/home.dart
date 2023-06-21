import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../functions/logout.dart';
import 'chat.dart';
import 'group.dart';
import './profile.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController search = TextEditingController();

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await firestore
        .collection('users')
        .where("name", isEqualTo: search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
    });
  }

  // void setupPushNotifications() async {
  //   final fcm = FirebaseMessaging.instance;

  //   fcm.requestPermission();
  //   // final token = await fcm.getToken();
  //   // print(token);

  //   fcm.subscribeToTopic('chat');
  // }

  // @override
  // void initState() {
  //   super.initState();

  //   setupPushNotifications();
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ));
            },
            icon: const CircleAvatar(child: Icon(Icons.person))),
        title: Text("Chats of ${auth.currentUser?.displayName}"),
        actions: [
          IconButton(
              onPressed: () => logOut(context),
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: isLoading
          ? Center(
              child: SizedBox(
                height: size.height / 20,
                width: size.width,
                child: const CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width,
                  height: size.height / 14,
                  child: SizedBox(
                    height: size.height / 14,
                    width: size.width / 1.2,
                    child: TextField(
                      controller: search,
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                  onPressed: onSearch,
                  child: const Text("Search"),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                userMap != null
                    ? ListTile(
                        onTap: () {
                          String roomId = chatRoomId(
                              auth.currentUser!.displayName!, userMap!['name']);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatRoom(
                                chatRoomId: roomId,
                                userMap: userMap!,
                              ),
                            ),
                          );
                        },
                        leading:
                            const Icon(Icons.account_box, color: Colors.black),
                        title: Text(
                          userMap!['name'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(userMap!['email']),
                        trailing: const Icon(Icons.chat, color: Colors.black),
                      )
                    : Container(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.group),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const GroupScreen()))),
    );
  }
}
