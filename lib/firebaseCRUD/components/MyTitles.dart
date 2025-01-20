import 'package:flutter/material.dart';

class MyTitle extends StatelessWidget{
  String title;
  int? size;
  MyTitle({super.key, required this.title,this.size});

  Widget build(BuildContext context){
    return Text(
      title,
      style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: size == null ? 40 : 25 ,
          fontWeight: FontWeight.bold),
    );
  }
}