import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../Utilities/PointerDetails.dart';
import '../Utilities/Tool.dart';
import 'Notepage.dart';


class Editor extends StatefulWidget {
  final bool isTooling;

  const Editor({super.key, required this.isTooling});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {


  int pointerCount = 0;

  @override
  Widget build(BuildContext context) {
    void onInteractionStart(ScaleStartDetails event) {
      setState(() {
        pointerCount = event.pointerCount;
      });
    }

    void onInteractionUpdate(ScaleUpdateDetails event) {
      print(pointerCount);
      setState(() {
        pointerCount = event.pointerCount;
      });
    }

    void onInteractionEnd(ScaleEndDetails event) {
      setState(() {
        pointerCount = event.pointerCount;
      });
    }

    return (SizedBox.expand(
        child: InteractiveViewer(
            onInteractionStart: onInteractionStart,
            onInteractionUpdate: onInteractionUpdate,
            onInteractionEnd: onInteractionEnd,
            constrained: false,
            panEnabled: (pointerCount == 2),
            panAxis: PanAxis.horizontal,
            scaleEnabled: (pointerCount == 2),
            clipBehavior: Clip.none,
            child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 800,
                        width: 500,
                        child: Notepage(isTooling: pointerCount != 2)
                      ),
                      SizedBox(
                          height: 800,
                          width: 500,
                          child: Notepage(isTooling: pointerCount != 2)
                      ),
                    ],
                  ),
                ),
            )


        ));
  }
}


