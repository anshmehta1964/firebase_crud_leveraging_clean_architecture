import 'package:flutter/material.dart';

class AuthTitle extends StatelessWidget{
  final String title;
  final double size;
  const AuthTitle({
    super.key,
    required this.title,
    this.size = 40});


  @override
  Widget build(BuildContext context){
    return Text(
      title,
      style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: size,
          fontWeight: FontWeight.bold),
    );
  }
}