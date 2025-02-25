import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Toolbar.dart';

class Background extends StatefulWidget {
  final Widget child;
  final bool isMoving;
  const Background({super.key, required this.child, required this.isMoving});

  @override
  State<Background> createState() => _BackgroundState();
}


class _BackgroundState extends State<Background> {
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
    ColoredBox (
      color: Colors.grey,
      child: Column(
        children: [
          Row(
            children: [Toolbar()],
          ),
          Row(
            children: [
              InteractiveViewer(
                    onInteractionStart: onInteractionStart,
                    onInteractionEnd: onInteractionEnd,
                    panEnabled: widget.isMoving && (pointerCount == 2),
                    scaleEnabled: widget.isMoving && (pointerCount == 2),
                    minScale: 0.1,

                    child: SizedBox(
                      height: 500,
                      width: 300,
                      child: widget.child,
                    ),
                  )
            ],
          )
        ],
      ),
    )




    );
  }
}