import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MyDialogBox.dart';

class TempScreen extends StatelessWidget {

  const TempScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CupertinoButton(
          color: Colors.white,
            child: Text('Click Me', style: TextStyle(color: Colors.black),),
            onPressed: (){
             showDialog(
                 context: context,
                 builder: (context)=> Mydialogbox(
                     title: "Test",
                     content: "Checking",
                     btnText1: "Cancel",
                     btnText2: "Ok",
                     onBtn1pressed: (){
                       Navigator.pop(context);
                       a();
                     },
                     onBtn2pressed: (){
                       Navigator.pop(context);
                       b();
                     })
             );
            },
        ),
      )
    );
  }

  void a(){
    print("Cancel button clicked!");
  }

  void b(){
    print("Ok button clicked");
  }
}
