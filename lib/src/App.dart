import 'dart:io';

import 'package:dreamnote/src/Editor/Editor.dart';
import 'package:dreamnote/src/Utilities/PointerDetails.dart';
import 'package:dreamnote/src/Utilities/Tool.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import 'Utilities/NoteType.dart';
import 'Utilities/Save.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}
class _AppState extends State<App> {

  late NoteType note;

  String cutDirectory(String path) {
    return path.split("/").last;
  }
  Future<void> loadBeforeApp() async {
    if(Save.inited()) {
      return;
    }
    setState(() async {
      await Save.init();
      note = NoteType.parseData(Save.readFile("${cutDirectory(Save.filesInFolder().first.path)}/paths"));
    });

  }
  Future<void> savePDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      file.copy('${Save.devicePath}/DreamNote/${note.noteName}/pdf.pdf');
      for(int i = 0; i < (await Save.loadPDF('${note.noteName}/pdf.pdf'))!.pages.length; i++) {
        note.addPage();
      }
    } else {
      // User canceled the picker
    }

  }

  @override
  Widget build(BuildContext context) {
    PointerDetails pointerDetails = PointerDetails();
    return FutureBuilder(future: Future<void>(loadBeforeApp),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return (Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(onPressed: () => pointerDetails.setTool(newTool: Tool.pen), icon: Text("Pen")),
                  IconButton(onPressed: () => pointerDetails.setTool(newTool: Tool.eraser), icon: Text("Eraser")),
                  IconButton(onPressed: () => savePDF(), icon: Text("PDF")),
                ],
              ),
              drawer: Drawer(
                child: ListView(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          NoteType newNote = NoteType("Untitled Note");
                          newNote.addPage();
                          note = newNote;
                        });
                      },
                      icon: Text("New Note"),
                    ),
                    for(FileSystemEntity file in Save.filesInFolder())
                      IconButton(
                        onPressed: () {},
                        icon:Text(cutDirectory(file.path)),

                      )
                  ],
                ),
              ),
              body: Stack(
                children: [
                  Container(color: Colors.purple),
                  Editor(
                    isTooling: true,
                    pointerDetails: pointerDetails,
                    note: note,
                  ),
                ],
              )));

        } else {
          return Text("Loading");

        }

      },

    );
  }
}
