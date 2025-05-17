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
  PointerDetails details = PointerDetails();

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
  Future<void> makePdfNote() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      //set up newNote
      NoteType newNote = NoteType();
      newNote.setNoteName(result.files.single.name.replaceAll('.pdf', ''));

      File file = File(result.files.single.path!);
      //create the new note directory
      await Directory('${Save.devicePath}/DreamNote/${newNote.getNoteName()}').create(recursive: true);
      //copies it in
      await file.copy('${Save.devicePath}/DreamNote/${newNote.getNoteName()}/pdf.pdf');

      //loads pdf
      PdfDocument? pdf = await Save.loadPDF('${note.getNoteName()}/pdf.pdf');
      if(pdf != null) {
        newNote.setPageNum(pdf.pages.length);
        setState(() {
          note = newNote;
        });
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: loadBeforeApp(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return ( Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(onPressed: () => details.setTool(newTool: Tool.pen), icon: Text("Pen")),
                  IconButton(onPressed: () => details.setTool(newTool: Tool.eraser), icon: Text("Eraser")),
                  IconButton(onPressed: () => details.toggleTool(newTool: Tool.move), icon:Text("Toggle Tools"))
                ],
              ),
              drawer: Drawer(
                child: ListView(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          NoteType newNote = NoteType();
                          newNote.addPage();
                          note = newNote;
                        });
                      },
                      icon: Text("New Note"),
                    ),
                    IconButton(
                      onPressed: makePdfNote,
                      icon: Text("New PDF"),
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
                    pointerDetails: details,
                    note: note,
                  ),
                ],
              )));

        } else {
          return CircularProgressIndicator();

        }

      },

    );
  }
}
