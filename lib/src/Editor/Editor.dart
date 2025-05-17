import 'package:dreamnote/src/Utilities/NoteType.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import '../Utilities/PointerDetails.dart';
import '../Utilities/Save.dart';
import 'Notepage.dart';

class Editor extends StatefulWidget {
  final bool isTooling;
  final PointerDetails pointerDetails;
  final NoteType note;

  const Editor(
      {super.key,
      required this.isTooling,
      required this.pointerDetails,
      required this.note});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  bool isMoving = false;
  PdfDocument? pdf;
  Future<void> loadPdf() async {
    pdf = await Save.loadPDF('${widget.note.noteName}/pdf.pdf');
  }
  @override
  void initState() {
    super.initState();
    setState(() {
      loadPdf();
    });
    print(pdf?.pages.length);
  }

  @override
  Widget build(BuildContext context) {
    void onInteractionStart(ScaleStartDetails event) {
      setState(() {
        if (event.pointerCount > 1) {
          isMoving = true;
        } else {
          isMoving = false;
        }
      });
    }

    void onInteractionEnd(ScaleEndDetails event) {
      setState(() {
        if (event.pointerCount > 1) {
          isMoving = true;
        } else {
          isMoving = false;
        }
      });
    }

    return (SizedBox.expand(
        child: InteractiveViewer(
      onInteractionStart: onInteractionStart,
      onInteractionEnd: onInteractionEnd,

      constrained: false,
      panEnabled: isMoving,
      scaleEnabled: isMoving,
      trackpadScrollCausesScale: true,
      maxScale: 100,
      minScale: .2,
      boundaryMargin: EdgeInsets.only(left: 100, right: 100),
      child: Center(
        child: Column(
          children: [
            for (int i = 0; i < widget.note.numOfPages; i++)
              SizedBox(
                width: pdf?.pages[i].width,
                height: pdf?.pages[i].height,
                child: Notepage(
                isTooling: !isMoving,
                pointerDetails: widget.pointerDetails,
                pageNum: i,
                note: widget.note,
                child: PdfPageView(document: pdf, pageNumber: i,),
                )
              ),
          ],
        ),
      ),
    )));
  }
}
