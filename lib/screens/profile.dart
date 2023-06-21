import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/profile_edit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool flag = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
            alignment: Alignment.center,
            height: size.height / 4,
            child: const CircleAvatar(
              maxRadius: 70,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  Icons.person,
                  size: 70,
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              child: EditProfile("ABOUT", flag),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              child: EditProfile("name", flag),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              child: EditProfile("email", flag),
            ),
          ),
          SizedBox(
            height: size.height / 15,
          ),
          TextButton(
            onPressed: () => setState(() {
              flag = !flag;
            }),
            child: Text(
              "Edit Account",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      )),
    );
  }
}
