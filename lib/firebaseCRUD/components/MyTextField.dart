import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget{
  final TextEditingController controller;
  final String hintText;
  final bool? obscureText;
  final Function(String) onTextChanged;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onTextChanged,
    this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText == null ? false : true,
      obscuringCharacter: '*',
      controller: controller,
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)),
          fillColor: Theme.of(context).colorScheme.tertiary,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500])),
      onChanged: onTextChanged,
    );
  }
}