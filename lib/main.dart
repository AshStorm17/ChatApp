import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/home.dart';
import './authentication/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
      },
      home: (_auth.currentUser != null)
          ? const HomeScreen()
          : const LoginScreen(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 233, 183, 34),
        ),
        primarySwatch: Colors.amber,
        hintColor: const Color.fromARGB(198, 161, 126, 18),
        // colorScheme: const ColorScheme(
        //   brightness: Brightness.light,
        //   primary: Color.fromARGB(255, 196, 153, 22),
        //   onPrimary: Colors.white,
        //   secondary: Color.fromARGB(193, 177, 88, 193),
        //   onSecondary: Colors.white,
        //   error: Colors.red,
        //   onError: Colors.white,
        //   background: Color.fromARGB(213, 233, 225, 225),
        //   onBackground: Color.fromARGB(213, 233, 225, 225),
        //   surface: Color.fromARGB(171, 255, 255, 255),
        //   onSurface: Color.fromARGB(231, 255, 255, 255),
        // )
        // canvasColor: const Color.fromARGB(192, 193, 190, 183),
      ),
    );
  }
}
