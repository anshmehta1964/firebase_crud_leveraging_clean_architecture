import 'dart:async';

import 'package:flutter/material.dart';

class basicStream extends StatefulWidget {
  basicStream({super.key});

  State<basicStream> createState() => _basicStreamState();
}

class _basicStreamState extends State<basicStream> {
  int counter = 0;
  StreamController<int> counterController = StreamController.broadcast();
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child:StreamBuilder(
              stream: counterController.stream,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return Text(snapshot.data.toString(),
                  style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold
                    ),
                  );
                } else {
                  return Text("0",
                    style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold
                    )
                  );
                }
              }
          )
        ),
      ),
      persistentFooterButtons: [
        FloatingActionButton(
          onPressed: (){
            // counter++;
            counterController.sink.add(counter++);
          },
          child: Icon(Icons.add),
        ),
        FloatingActionButton(
          onPressed: (){
            // counter++;
            counterController.sink.add(counter--);
          },
          child: Icon(Icons.label_off_outlined),
        ),
      ],
    );
  }
}
