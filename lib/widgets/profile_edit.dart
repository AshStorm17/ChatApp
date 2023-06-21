import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  EditProfile(this.detail, this.flag, {super.key});
  final TextEditingController editDetail = TextEditingController();

  final String detail;
  final bool flag;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height / 25,
      width: size.width / 1.1,
      child: flag
          ? Text(
              detail,
              style: const TextStyle(fontSize: 20),
            )
          : TextField(
              controller: editDetail,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                hintText: detail,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
    );
  }
}
