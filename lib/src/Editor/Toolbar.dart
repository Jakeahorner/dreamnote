import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Toolbar extends StatefulWidget {
  final Widget child;
  final bool isMoving;
  const Toolbar({super.key, required this.child, required this.isMoving});

  @override
  State<Toolbar> createState() => _ToolbarState();
}


class _ToolbarState extends State<Toolbar> {
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

    return(
        ColoredBox(
            color: Colors.grey,
            child: InteractiveViewer(
              onInteractionStart: onInteractionStart,
              onInteractionEnd: onInteractionEnd,
              panEnabled: widget.isMoving && (pointerCount == 2),
              scaleEnabled: widget.isMoving && (pointerCount == 2),
              minScale: 0.1,

              child: SizedBox(
                height: 500,
                width: 200,
                child: widget.child,
              ),
            )
        )

    );
  }
}