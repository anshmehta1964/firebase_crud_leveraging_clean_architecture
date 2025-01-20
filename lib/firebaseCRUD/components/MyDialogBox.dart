import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Mydialogbox extends StatelessWidget {
  String title;
  String content;
  String btnText1;
  String btnText2;
  VoidCallback onBtn1pressed;
  VoidCallback onBtn2pressed;
  Mydialogbox({
    super.key,
    required this.title,
    required this.content,
    required this.btnText1,
    required this.btnText2,
    required this.onBtn1pressed,
    required this.onBtn2pressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        MaterialButton(
          onPressed: onBtn1pressed,
          // color: Colors.green[300],
          child: Text(btnText1),
        ),
        MaterialButton(
          onPressed: onBtn2pressed,
          // color: Colors.red[300],
          child: Text(btnText2),
        ),
      ],
    );
  }
}
