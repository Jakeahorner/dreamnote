import 'dart:core';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/widgets.dart';

class NoteType {
  int version = 1;
  String noteName = "Untitled Note";
  int numOfPages = 0;
  //this 3D array is page containing path containing path commands
  List<List<List<String>>> pathCommandsPerPage = [];
  NoteType(this.noteName);

  void savePage(int pageNum, List<List<String>> pathCommands) {
    //save to the page in the list index
    if(pathCommandsPerPage.length <= pageNum) {
      //inserts here because
      addPage();
      savePage(pageNum, pathCommands);
    } else {
      pathCommandsPerPage[pageNum] = pathCommands;
    }
  }
  void addPage() {
    numOfPages++;
    pathCommandsPerPage.add([]);

  }

  String getData() {
    StringBuffer buffer = StringBuffer();

    //1-version number
    buffer.writeln(version);
    //2-Note Name
    buffer.writeln(noteName);
    //3-Number of pages
    buffer.writeln(numOfPages);
    //rest of file is path data
    for(List<List<String>> page in pathCommandsPerPage) {
      for(List<String> pathCommands in page) {
        for (String command in pathCommands) {
          buffer.writeln(command);
        }
        buffer.writeln("--ENDOFPATH--");
      }
      //insert a "--ENDOFPAGE--" to indicate that the next page should be interpreted
      buffer.writeln("--ENDOFPAGE--");
    }
    buffer.write("--ENDOFFILE--");
    return buffer.toString();
  }
  static Path commandsToPath(List<String> commands) {
    Path newPath = Path();
    for (String command in commands) {
      List<String> splitCommand = command.split(" ");
      switch(splitCommand[0]) {
        case "M":
          newPath.moveTo(double.parse(splitCommand[1]), double.parse(splitCommand[2]));
        case "L":
          newPath.lineTo(double.parse(splitCommand[1]), double.parse(splitCommand[2]));
      }
    }
    return newPath;

  }
  static NoteType parseData(String data) {
    NoteType newNoteType = NoteType("Untitled Note");
    List<List<List<String>>> newPathCommands = [];
    List<String> lines = data.split("\n");
    newNoteType.version = int.parse(lines[0]);
    newNoteType.noteName = lines[1];
    newNoteType.numOfPages = int.parse(lines[2]);
    //removes lines already read and goes to 3 because it exculsive
    lines.removeRange(0, 3);
    //makes a new page
    newPathCommands.add([[]]);
    for(String line in lines) {
      if(line == "--ENDOFPAGE--") {
        if(newPathCommands.last.isNotEmpty) {
          newPathCommands.last.removeLast();
        }
        newPathCommands.add([[]]);
        continue;
      }
      if(line == "--ENDOFPATH--") {
        newPathCommands.last.add([]);
        continue;
      }
      if(line == "--ENDOFFILE--") {
        //removes the made empty lists
        newPathCommands.removeLast();
        break;
      }
      newPathCommands.last.last.add(line);
    }
    newNoteType.pathCommandsPerPage = newPathCommands;
    return newNoteType;
  }

}