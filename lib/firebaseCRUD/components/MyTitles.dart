import 'package:flutter/material.dart';

class MyTitle extends StatelessWidget{
  final String title;
  final int? size;
  const MyTitle({super.key, required this.title,this.size});


  @override
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