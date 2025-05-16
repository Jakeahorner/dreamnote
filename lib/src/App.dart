import 'package:dreamnote/src/Editor/Editor.dart';
import 'package:dreamnote/src/Utilities/PointerDetails.dart';
import 'package:dreamnote/src/Utilities/Tool.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    PointerDetails pointerDetails = PointerDetails();
    return (Scaffold(
        appBar: AppBar(
          actions: [
            Expanded(
              child: IconButton(onPressed: () => pointerDetails.setTool(newTool: Tool.pen), icon: Text("Pen")),
            ),
            Expanded(
              child: IconButton(onPressed: () => pointerDetails.setTool(newTool: Tool.eraser), icon: Text("Eraser")),
            )
          ],
        ),
        body: Stack(
      children: [
        Container(color: Colors.purple),
        Editor(
          isTooling: true,
          pointerDetails: pointerDetails,
        ),
      ],
    )));
  }
}
