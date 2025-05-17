import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';

import 'Stylus.dart';
import 'Tool.dart';

class PointerDetails extends ChangeNotifier {
  Tool _tool = Tool.pen;
  Stylus stylus = Stylus();
  final List<int> _pointerDeviceIds = [];
  PointerEvent? event;


  Tool getTool() {
    return _tool;
  }

  setTool({required Tool newTool}) {
    _tool = newTool;
    notifyListeners();
  }

  bool isMuliTouched() {
    return _pointerDeviceIds.length > 1;
  }
  int pointerCount() {
    return _pointerDeviceIds.length;
  }

  void addPointer(PointerEvent event) {
    removeHoveringPointer();
    this.event = event;
    _pointerDeviceIds.add(event.device);
    if(event.kind == PointerDeviceKind.stylus) {
      stylus.isEnabled = true;
      if(event.buttons == 2) {
        stylus.isButtonDown = true;
      } else {
        stylus.isButtonDown = false;
      }
    } else {
      stylus.isEnabled = false;
    }
    notifyListeners();
  }

  clearPointers() {
    _pointerDeviceIds.clear();
    notifyListeners();
  }
  removePointer(PointerEvent event) {
    removeHoveringPointer();
    _pointerDeviceIds.remove(event.device);
    notifyListeners();
  }

  Offset getPosition() {
    if(event == null) {
      return Offset(0, 0);
    } else {
      return Offset(event!.localPosition.dx, event!.localPosition.dy);
    }
  }

  addHoveringPointer(PointerEvent newEvent) {
    stylus.isHovering = true;
    stylus.hoveringLocation = Offset(newEvent.localPosition.dx, newEvent.localPosition.dy);
    notifyListeners();
  }

  removeHoveringPointer() {
    stylus.isHovering = false;
    stylus.hoveringLocation = Offset(0,0);
    notifyListeners();
  }

}