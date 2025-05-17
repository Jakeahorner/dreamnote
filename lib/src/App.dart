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

  late ValueNotifier<NoteType> note;
  PointerDetails details = PointerDetails();

  String cutDirectory(String path) {
    return path.split("/").last;
  }
  @override
  void initState() {
    super.initState();
    Save.init().then((done) {
      note = ValueNotifier<NoteType>(makeNewNote());
      note.addListener(onNoteChange);
      if(Save.filesInFolder().isNotEmpty) {
        note.value = NoteType.parseData(Save.readFile("${cutDirectory(Save.filesInFolder().last.path)}/paths"));
      } else {
        makeNewNote();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    note.removeListener(onNoteChange);
  }

  void onNoteChange() {
    setState(() {

    });
  }

  NoteType makeNewNote() {
    NoteType newNote = NoteType();
    newNote.setNoteName('Untitled Note - ${DateTime.now()}');
    newNote.addPage();
    Save.saveFile('${newNote.getNoteName()}/paths', newNote.getData());
    return newNote;
  }
  Future<NoteType?> makePdfNote() async {
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
      PdfDocument? pdf = await Save.loadPDF('${newNote.getNoteName()}/pdf.pdf');
      if(pdf != null) {
        newNote.setPageNum(pdf.pages.length);
        return newNote;
      }
    }
    return null;

  }


  @override
  Widget build(BuildContext context) {
    if(!Save.inited()) {
      return CircularProgressIndicator();
    }
      return (
          Scaffold(

          appBar: AppBar(
            title: Text(note.value.getNoteName()),
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
                    note.value = makeNewNote();
                  },
                  icon: Text("New Note"),
                ),
                IconButton(
                  onPressed: () async {
                    NoteType? pdfNote = await makePdfNote();
                    if(pdfNote != null) {
                      note.value = pdfNote;
                    }
                  },
                  icon: Text("New PDF"),
                ),
                for(FileSystemEntity file in Save.filesInFolder())
                  IconButton(
                    onPressed: () {
                      note.value = NoteType.parseData(Save.readFile('${cutDirectory(file.path)}/paths'));
                    },
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
  }
}
