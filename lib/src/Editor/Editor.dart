import 'package:dreamnote/src/Editor/PageBackground.dart';
import 'package:dreamnote/src/Utilities/NoteType.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import '../Utilities/PointerDetails.dart';
import '../Utilities/Save.dart';
import '../Utilities/Tool.dart';
import 'Notepage.dart';

class Editor extends StatefulWidget {
  final PointerDetails pointerDetails;
  final ValueNotifier<NoteType> note;

  const Editor({
    super.key,
    required this.pointerDetails,
    required this.note,
  });

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  PdfDocument? pdf;

  void onNoteChange() {
    Save.loadPDF('${widget.note.value.getNoteName()}/pdf.pdf').then((pdf) {
      setState(() {
        this.pdf = pdf;
      });
    });
  }
  void onPointerDetailChange() {
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    widget.note.addListener(onNoteChange);
    widget.pointerDetails.addListener(onPointerDetailChange);
  }
  @override
  void dispose() {
    super.dispose();
    widget.note.removeListener(onNoteChange);
    widget.pointerDetails.removeListener(onPointerDetailChange);
  }

  @override
  Widget build(BuildContext context) {

    return (SizedBox.expand(
      child: InteractiveViewer(
      constrained: false,
      panEnabled: widget.pointerDetails.getTool() == Tool.move || widget.pointerDetails.isMuliTouched(),
      scaleEnabled: widget.pointerDetails.getTool() == Tool.move || widget.pointerDetails.isMuliTouched(),
      maxScale: 2.5,
      minScale: .8,
      boundaryMargin: EdgeInsets.only(left: 1000, right: 1000, bottom: 1000, top:1000 ),
      child: Center(
        child: Column(
          children: [
            for (int i = 0; i < widget.note.value.getNumberOfPages(); i++)
              Column(
                children: [
                  Notepage(
                    pointerDetails: widget.pointerDetails,
                    pageNum: i,
                    note: widget.note,
                    pdf: pdf
                  ),
                  Container(height: 20,)
                ],
              )
          ],
        ),
      ),
    )));
  }
}
