import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Editor extends StatefulWidget {
  final bool isTooling;
  const Editor({super.key, required this.isTooling});

  @override
  State<Editor> createState() => _EditorState();
}


class _EditorState extends State<Editor> {


  Offset currentPointerPoint = Offset.zero;
  Path path = Path();
  List<Path> pathStack = [];
  bool usingStylus = false;
  bool stylusHovering = false;
  bool stylusButtonDown = false;
  Offset stylusHoverLocation = Offset.zero;
  List<int> pointers = [];
  bool multitouched = false;


  void onPointerDown(PointerDownEvent event) {
    setState(() {
      pointers.add(event.device);
      multitouched = pointers.length > 1;

      if(widget.isTooling && !multitouched) {
        path.moveTo(event.localPosition.dx, event.localPosition.dy);

        stylusHovering = false;
        if (event.kind == PointerDeviceKind.stylus) {
          usingStylus = true;
        }
      } else {
        path = Path();
      }
    });
  }
  void onPointerMove(PointerMoveEvent event) {
    setState(() {
      if(widget.isTooling && !multitouched) {
        path.lineTo(event.localPosition.dx, event.localPosition.dy);
      }
    });

  }
  void onPointerHover(PointerHoverEvent event) {
    setState(() {
      if(event.kind == PointerDeviceKind.stylus) {
        stylusHovering = true;
        usingStylus = true;
        stylusHoverLocation = event.localPosition;
      }
    });
  }

  void onPointerUp(PointerUpEvent event) {
    setState(() {
      if(!multitouched) {
        pathStack.add(path);
      }
      path = Path();
      pointers.remove(event.device);

      stylusHovering = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return(
      Listener(
        //detects stylus
        onPointerDown: onPointerDown,
        onPointerHover: onPointerHover,
        onPointerUp: onPointerUp,
        onPointerMove: onPointerMove,
        child: CustomPaint(
              foregroundPainter: StylusPaint(hoverLocation: stylusHoverLocation, shouldShowDot: stylusHovering),
              child: CustomPaint(
                foregroundPainter: LoadPaint(paths: pathStack),
                child: CustomPaint(
                  foregroundPainter: CurrentPaint(path: path),
                  child: ColoredBox(color: Colors.white),
                ),
              ),
            )
      )
    );
  }
}

class LoadPaint extends CustomPainter {

  final List<Path> paths;

  LoadPaint({
    required this.paths,
  });

  @override


  @override
  void paint(Canvas canvas, Size size) {
    for(Path loadedpath in paths) {
      final Paint paint = Paint();
      paint.color = Colors.black;
      paint.style = PaintingStyle.stroke;
      paint.strokeCap = StrokeCap.round;
      paint.strokeWidth = 5;

      canvas.drawPath(loadedpath, paint);
    }

  }

// Since this Sky painter has no fields, it always paints
// the same thing and semantics information is the same.
// Therefore we return false here. If we had fields (set
// from the constructor) then we would return true if any
// of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(LoadPaint oldDelegate) => false;
}

class CurrentPaint extends CustomPainter {

  final Path path;

  CurrentPaint({
    required this.path,
  });

  @override


  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    paint.strokeWidth = 5;

    canvas.drawPath(path, paint);
  }

// Since this Sky painter has no fields, it always paints
// the same thing and semantics information is the same.
// Therefore we return false here. If we had fields (set
// from the constructor) then we would return true if any
// of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(CurrentPaint oldDelegate) => true;
}

class StylusPaint extends CustomPainter {

  final Offset hoverLocation;
  final bool shouldShowDot;

  StylusPaint({
    required this.hoverLocation,
    required this.shouldShowDot,

  });

  @override


  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = Colors.grey;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    paint.strokeWidth = 5;

    if(shouldShowDot) {
      canvas.drawCircle(hoverLocation, 0.5, paint);
    }
  }

// Since this Sky painter has no fields, it always paints
// the same thing and semantics information is the same.
// Therefore we return false here. If we had fields (set
// from the constructor) then we would return true if any
// of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(StylusPaint oldDelegate) => true;
}