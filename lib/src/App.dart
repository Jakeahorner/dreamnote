import 'package:dreamnote/src/Editor/Editor.dart';
import 'package:dreamnote/src/Editor/Toolbar.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        body: Stack(
      children: [
        Container(color: Colors.purple),
        Editor(
          isTooling: true,
        ),
        Toolbar(),
      ],
    )));
  }
}
