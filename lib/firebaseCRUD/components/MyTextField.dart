import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool? obscureText;
  final Function(String) onTextChanged;

  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.onTextChanged,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText == null ? false : true,
      obscuringCharacter: '*',
      controller: controller,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.black54)),
          fillColor: Theme.of(context).colorScheme.tertiary,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500])),
      onChanged: onTextChanged,
    );
  }
}
