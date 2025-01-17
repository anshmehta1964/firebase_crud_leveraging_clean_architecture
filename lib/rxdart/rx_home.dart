import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';


class rxHome extends HookWidget {
  const rxHome({super.key});

  @override
  Widget build(BuildContext context) {
    // create behaviorSubject everytime widget is re built
    final subject = useMemoized(
            ()=> BehaviorSubject<String>(),
        [key]
    );

    //dispose of the old subject every time the widget is rebuilt
    useEffect(
        ()=> subject.close,
        [subject]
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text(
          'Hooks',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}

