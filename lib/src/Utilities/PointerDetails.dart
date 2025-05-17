import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';

import 'Stylus.dart';
import 'Tool.dart';

class PointerDetails extends ChangeNotifier {
  Tool _tool = Tool.pen;
  Tool _defaultTool = Tool.pen;
  Stylus stylus = Stylus();
  final List<int> _pointerDeviceIds = [];
  bool _multiTouched = false;
  PointerEvent? event;

  PointerDetails();

  Tool getTool() {
    if(stylus.isEnabled && stylus.isButtonDown) {
      _tool = Tool.eraser;
    } else if (stylus.isEnabled){
      _tool = Tool.pen;
    }
    if(_multiTouched) {
      return Tool.move;
    }
    return _tool;
  }

  setTool({required Tool newTool}) {
    _tool = newTool;
    notifyListeners();
  }
  setDefaultTool({required Tool newTool}) {
    _defaultTool = newTool;
    notifyListeners();
  }
  Tool getDefaultTool() {
    return _defaultTool;

  }
  void toggleTool({required Tool newTool}) {
    if(_tool == newTool) {
      setTool(newTool: _defaultTool);
    } else {
      setDefaultTool(newTool: _tool);
      setTool(newTool: newTool);
    }
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
    removeHoveringPointer();
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