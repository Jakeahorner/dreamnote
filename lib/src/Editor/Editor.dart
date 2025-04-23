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

    void onInteractionEnd(ScaleEndDetails event) {
      setState(() {
        pointerCount = event.pointerCount;
      });
    }

    return (SizedBox.expand(
        child: InteractiveViewer(
            onInteractionStart: onInteractionStart,
            onInteractionEnd: onInteractionEnd,
            panEnabled: (pointerCount == 2),
            scaleEnabled: (pointerCount == 2),
            clipBehavior: Clip.none,
            child: Center(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 800,
                      width: 500,
                      child: Notepage(isTooling: widget.isTooling),
                    ),
                    SizedBox(
                      height: 800,
                      width: 500,
                      child: Notepage(isTooling: widget.isTooling),
                    ),
                    SizedBox(
                      height: 800,
                      width: 500,
                      child: Notepage(isTooling: widget.isTooling),
                    )

                  ],
                ),
              ),
            )


        ));
  }
}


