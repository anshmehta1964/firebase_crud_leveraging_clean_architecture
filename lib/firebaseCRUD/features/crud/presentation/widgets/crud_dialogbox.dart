import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CrudDialogbox extends StatelessWidget {
  final String title;
  final String content;
  final String btnText1;
  final String btnText2;
  final VoidCallback onBtn1pressed;
  final VoidCallback onBtn2pressed;
  const CrudDialogbox({
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
