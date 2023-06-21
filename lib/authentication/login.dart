import 'package:flutter/material.dart';

import '../screens/home.dart';
import './create.dart';
import '../functions/login.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoading
          ? Center(
              child: SizedBox(
                height: size.height / 20,
                width: size.height / 20,
                child: const CircularProgressIndicator(),
              ),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: size.width / 1.1,
                      child: Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width / 1.1,
                      child: const Text(
                        "Sign In to Contiue!",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 10,
                    ),
                    Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: size.height / 14,
                        width: size.width / 1.1,
                        child: TextField(
                          controller: _email,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.account_box),
                            hintText: "email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: size.height / 14,
                          width: size.width / 1.1,
                          child: TextField(
                            controller: _password,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              hintText: "password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_email.text.isNotEmpty &&
                            _password.text.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });

                          logIn(_email.text, _password.text).then((user) {
                            if (user != null) {
                              print("Login Sucessfull");
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pushNamedAndRemoveUntil(context,
                                  HomeScreen.routeName, (route) => false);
                            } else {
                              print("Login Failed");
                              setState(() {
                                isLoading = false;
                              });
                            }
                          });
                        } else {
                          print("Please fill form correctly");
                        }
                      },
                      child: Container(
                        height: size.height / 14,
                        width: size.width / 1.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).primaryColor,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 40,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const CreateAccount())),
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
