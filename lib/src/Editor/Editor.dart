import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../Utilities/PointerDetails.dart';
import '../Utilities/Tool.dart';
import 'Notepage.dart';


class Editor extends StatefulWidget {
  final bool isTooling;
  final PointerDetails pointerDetails;

  const Editor({super.key, required this.isTooling, required this.pointerDetails});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {


  bool isMoving = false;

  @override
  Widget build(BuildContext context) {
    void onInteractionStart(ScaleStartDetails event) {
      setState(() {
        if(event.pointerCount > 1) {
          isMoving = true;
        } else {
          isMoving = false;
        }
      });
    }

    void onInteractionEnd(ScaleEndDetails event) {
      setState(() {
        if(event.pointerCount > 1) {
          isMoving = true;
        } else {
          isMoving = false;
        }
      });
    }

    return (SizedBox.expand(
        child: InteractiveViewer(
            onInteractionStart: onInteractionStart,
            onInteractionEnd: onInteractionEnd,
            constrained: false,
            panEnabled: isMoving,
            panAxis: PanAxis.horizontal,
            scaleEnabled: isMoving,
            maxScale: 100,
            minScale: 0.5,
            boundaryMargin: EdgeInsets.only(left: 50, right: 50),
            child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 800,
                        width: 500,
                        child: Notepage(isTooling: !isMoving, pointerDetails: widget.pointerDetails,)
                      ),
                      SizedBox(
                          height: 800,
                          width: 500,
                          child: Notepage(isTooling: !isMoving, pointerDetails: widget.pointerDetails,)
                      ),
                    ],
                  ),
                ),
            )


        ));
  }
}


