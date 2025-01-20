import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCupertinoButton extends StatelessWidget{
  final VoidCallback onPress;
  final String title;
  final Color? color;
  const MyCupertinoButton({
    super.key,
    required this.onPress,
    required this.title,
    this.color
  });

  @override
  Widget build(BuildContext context){
    return CupertinoButton(
      color: color ?? Theme.of(context).colorScheme.primary ,
      onPressed: onPress,
      child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          )
      ),
    );
  }
}