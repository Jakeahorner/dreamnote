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
  final NoteType note;

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

  @override
  void initState() {
    super.initState();
    Save.loadPDF('${widget.note.getNoteName()}/pdf.pdf').then((pdf) {
     setState(() {
       this.pdf = pdf;
     });
    });

  }

  @override
  Widget build(BuildContext context) {

    return (SizedBox.expand(
      child: InteractiveViewer(
      constrained: false,
      panEnabled: widget.pointerDetails.getTool() == Tool.move,
      scaleEnabled: widget.pointerDetails.getTool() == Tool.move,
      maxScale: 100,
      minScale: .2,
      boundaryMargin: EdgeInsets.only(left: 100, right: 100),
      child: Center(
        child: Column(
          children: [
            for (int i = 0; i < widget.note.getNumberOfPages(); i++)
              Column(
                children: [
                  Notepage(
                    pointerDetails: widget.pointerDetails,
                    pageNum: i,
                    note: widget.note,
                    child: PageBackground(pdfPage: pdf == null ? null : PdfPageView(document: pdf, pageNumber: i + 1, maximumDpi: 2000,)),
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
