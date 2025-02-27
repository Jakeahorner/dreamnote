import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../Utilities/PointerDetails.dart';
import '../Utilities/Tool.dart';

class Editor extends StatefulWidget {
  final bool isTooling;

  const Editor({super.key, required this.isTooling});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  Path path = Path();
  List<Path> pathStack = [];
  PointerDetails pointerDetails = PointerDetails();

  void onPointerDown(PointerDownEvent event) {
    setState(() {
      pointerDetails.addPointer(event);

      if (widget.isTooling && !pointerDetails.isMuliTouched()) {
        path.moveTo(
            pointerDetails.getPosition().dx, pointerDetails.getPosition().dy);
      } else {
        path = Path();
      }
    });
  }

  void onPointerMove(PointerMoveEvent event) {
    setState(() {
      if (widget.isTooling && !pointerDetails.isMuliTouched()) {
        path.lineTo(event.localPosition.dx, event.localPosition.dy);
      }
    });
  }

  void onPointerHover(PointerHoverEvent event) {
    setState(() {
      pointerDetails.addHoveringPointer(event);
    });
  }

  void onPointerUp(PointerUpEvent event) {
    setState(() {
      if (!pointerDetails.isMuliTouched() &&
          pointerDetails.getTool() == Tool.pen) {
        pathStack.add(path);
      }
      path = Path();
      pointerDetails.removePointer(event);
    });
  }

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

    return (SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: InteractiveViewer(
          onInteractionStart: onInteractionStart,
          onInteractionEnd: onInteractionEnd,
          panEnabled: (pointerCount == 2),
          scaleEnabled: (pointerCount == 2),
          minScale: 0.1,
          boundaryMargin: const EdgeInsets.all(200.0),
          child: SizedBox(
            width: 500,
            height: 1000,
            child: Listener(
                //detects stylus
                onPointerDown: onPointerDown,
                onPointerHover: onPointerHover,
                onPointerUp: onPointerUp,
                onPointerMove: onPointerMove,
                child: CustomPaint(
                    foregroundPainter: Painter(
                        pointerDetails: pointerDetails,
                        pathStack: pathStack,
                        path: path),
                    child: ColoredBox(color: Colors.white))),
          )),
    ));
  }
}

class Painter extends CustomPainter {
  final Path path;
  List<Path> pathStack = [];
  PointerDetails pointerDetails;

  Painter({
    required this.pointerDetails,
    required this.path,
    required this.pathStack,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //Load past paths
    for (Path loadedPath in pathStack) {
      final Paint paint = Paint();
      paint.color = Colors.black;
      paint.style = PaintingStyle.stroke;
      paint.strokeCap = StrokeCap.round;
      paint.strokeWidth = 5;

      canvas.drawPath(loadedPath, paint);
    }

    //Pen Paint
    final Paint penPaint = Paint();
    penPaint.color = Colors.black;
    penPaint.style = PaintingStyle.stroke;
    penPaint.strokeCap = StrokeCap.round;
    penPaint.strokeWidth = 5;

    //hovering dot paint
    final Paint dotPaint = Paint();
    dotPaint.color = Colors.grey;
    dotPaint.style = PaintingStyle.stroke;
    dotPaint.strokeCap = StrokeCap.round;
    dotPaint.strokeWidth = 5;

    //manage hovering dot
    if (pointerDetails.stylus.isHovering) {
      canvas.drawCircle(pointerDetails.stylus.hoveringLocation, 0.5, dotPaint);
    }

    switch (pointerDetails.getTool()) {
      case Tool.pen:
        canvas.drawPath(path, penPaint);

      case Tool.eraser:
        for (Path path in pathStack) {
          Path intersection =
              Path.combine(PathOperation.union, this.path, path);
          print(intersection.getBounds());
          if (intersection.getBounds().isEmpty) {
            pathStack.remove(path);
          }
        }
    }
  }

// Since this Sky painter has no fields, it always paints
// the same thing and semantics information is the same.
// Therefore we return false here. If we had fields (set
// from the constructor) then we would return true if any
// of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(Painter oldDelegate) => true;
}
