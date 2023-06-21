import 'package:flutter/material.dart';

import '../functions/create.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
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
                      height: size.height / 20,
                    ),
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
                      child: Text(
                        "Create Account to Contiue!",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width,
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: size.height / 14,
                            width: size.width / 1.1,
                            child: TextField(
                              controller: _name,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.account_box),
                                hintText: "Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: Container(
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
                      height: size.height / 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_name.text.isNotEmpty &&
                            _email.text.isNotEmpty &&
                            _password.text.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });

                          createAccount(_name.text, _email.text, _password.text)
                              .then((user) {
                            if (user != null) {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pushNamedAndRemoveUntil(
                                  context, 'home', (route) => false);
                              print("Account Created Sucessfull");
                            } else {
                              print("Login Failed");
                              setState(() {
                                isLoading = false;
                              });
                            }
                          });
                        } else {
                          print("Please enter Fields");
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
                          "Create Account",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
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
