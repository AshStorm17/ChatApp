import 'package:chat_app/otp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});
  static String verify = '';

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  String phone = '';
  TextEditingController country = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    country.text = '+91';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/quiz-logo.png',
                height: 150,
                color: Colors.amber,
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Phone Verification',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Enter Your Phone number to get started.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: [
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 40,
                    child: TextField(
                      controller: country,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    '|',
                    style: TextStyle(
                      fontSize: 33,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        phone = value;
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Phone',
                      ),
                    ),
                  )
                ]),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: country.text + phone,
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {
                        PhoneScreen.verify = verificationId;
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OtpScreen(phone),
                              ));
                        });
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Send OTP'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
