import 'package:flutter/material.dart';

class MyTextInputFiled extends StatelessWidget {
  final String hintText;
  final String userValidationMessage;
  final TextEditingController controller;
  final void Function(String)? onChanged;

  const MyTextInputFiled({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.userValidationMessage,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(),
          hintText: hintText),
    );
  }
}