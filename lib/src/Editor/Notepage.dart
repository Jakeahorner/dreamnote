import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:r_tree/r_tree.dart';
import 'dart:math';
import '../Utilities/PointerDetails.dart';
import '../Utilities/Tool.dart';

class Notepage extends StatefulWidget {
  const Notepage({super.key, required this.isTooling, required this.pointerDetails});

  final bool isTooling;
  final PointerDetails pointerDetails;

  @override
  State<Notepage> createState() => _Notepage();
}

class _Notepage extends State<Notepage> with WidgetsBindingObserver{

  Path path = Path();
  List<Path> pathStack = [];
  RTree<Path> pathTree = RTree<Path>();

  void onPointerDown(PointerDownEvent event) {
    setState(() {
      widget.pointerDetails.addPointer(event);

      if (widget.isTooling && !widget.pointerDetails.isMuliTouched()) {
        path.moveTo(
            widget.pointerDetails.getPosition().dx, widget.pointerDetails.getPosition().dy);
      } else {
        path = Path();
      }
    });
  }

  void onPointerMove(PointerMoveEvent event) {
    setState(() {
      if (widget.isTooling && !widget.pointerDetails.isMuliTouched()) {
        path.lineTo(event.localPosition.dx, event.localPosition.dy);
      }
    });
  }

  void onPointerHover(PointerHoverEvent event) {
    setState(() {
      widget.pointerDetails.addHoveringPointer(event);
    });
  }

  void onPointerUp(PointerUpEvent event) {
    setState(() {
      if (widget.isTooling && !widget.pointerDetails.isMuliTouched() &&
          widget.pointerDetails.getTool() == Tool.pen) {
        pathStack.add(path);
        pathTree.add([RTreeDatum(Rectangle.fromPoints(Point(path.getBounds().topLeft.dx, path.getBounds().topLeft.dy), Point(path.getBounds().bottomRight.dx, path.getBounds().bottomRight.dy)), path)]);
      }
      path = Path();
      widget.pointerDetails.removePointer(event);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Listener(
      //detects stylus
        onPointerDown: onPointerDown,
        onPointerHover: onPointerHover,
        onPointerUp: onPointerUp,
        onPointerMove: onPointerMove,
          child: CustomPaint(
              foregroundPainter: Painter(
                  pointerDetails: widget.pointerDetails,
                  pathStack: pathStack,
                  path: path,
                  pathTree: pathTree),
              child:
                SizedBox.expand(
                  child: ColoredBox(color: Colors.white),
                ),
              ),
        );
  }

}

class Painter extends CustomPainter {
  final Path path;
  List<Path> pathStack = [];
  PointerDetails pointerDetails;
  RTree<Path> pathTree;

  Painter({
    required this.pointerDetails,
    required this.path,
    required this.pathStack,
    required this.pathTree,
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
        Offset eraserPoint = pointerDetails.stylus.hoveringLocation;
        List<RTreeDatum<Path>> eraserPaths = pathTree.search(Rectangle.fromPoints(Point(path.getBounds().topLeft.dx, path.getBounds().topLeft.dy), Point(path.getBounds().bottomRight.dx, path.getBounds().bottomRight.dy)));

        for (RTreeDatum<Path> testerPath in eraserPaths) {
          print(pathsIntersect(testerPath.value, path));

          if(pathsIntersect(testerPath.value, path)) {
            pathStack.remove(testerPath.value);
          }
        }
    }
  }
  bool pathsIntersect(Path pathA, Path pathB, {double tolerance = 2.0}) {
    if (!pathA.getBounds().inflate(tolerance).overlaps(pathB.getBounds())) return false;

    final metricsA = pathA.computeMetrics(forceClosed: false).toList();
    final metricsB = pathB.computeMetrics(forceClosed: false).toList();

    // Precompute sample points from B for quick lookup
    final List<Offset> pathBSamples = [];
    for (final metricB in metricsB) {
      for (double t = 0; t < metricB.length; t += 4.0) {
        final posB = metricB.getTangentForOffset(t)?.position;
        if (posB != null) pathBSamples.add(posB);
      }
    }

    // Check if any point from A is close to any point from B
    for (final metricA in metricsA) {
      for (double t = 0; t < metricA.length; t += 4.0) {
        final posA = metricA.getTangentForOffset(t)?.position;
        if (posA == null) continue;

        for (final posB in pathBSamples) {
          if ((posA - posB).distance <= tolerance) {
            return true;
          }
        }
      }
    }

    return false;
  }


  @override
  bool shouldRepaint(Painter oldDelegate) => true;
}