import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/gestures.dart';

import 'Stylus.dart';
import 'Tool.dart';

class PointerDetails {
  Tool _tool = Tool.pen;
  Stylus stylus = Stylus();
  final List<int> _pointerDeviceIds = [];
  bool _multiTouched = false;
  PointerEvent? event;

  PointerDetails();

  Tool getTool() {
    if(stylus.isEnabled && stylus.isButtonDown) {
      _tool = Tool.eraser;
    } else {
      _tool = Tool.pen;
    }
    return _tool;
  }

  setTool({required Tool newTool}) {
    _tool = newTool;
  }

  bool isMuliTouched() {
    return _multiTouched;
  }

  addPointer(PointerEvent event) {
    removeHoveringPointer();
    this.event = event;
    _pointerDeviceIds.add(event.device);
    if(_pointerDeviceIds.length > 1) {
      _multiTouched = true;
    } else {
      _multiTouched = false;
    }
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
  }

  clearPointers() {
    _pointerDeviceIds.clear();
  }
  removePointer(PointerEvent event) {
    _pointerDeviceIds.remove(event.device);
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
  }

  removeHoveringPointer() {
    stylus.isHovering = false;
    stylus.hoveringLocation = Offset(0,0);
  }

}