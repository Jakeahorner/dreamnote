import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pdfrx/pdfrx.dart';

class PageBackground extends StatelessWidget {
  PdfPageView? pdfPage;
  PageBackground({
    super.key,
    this.pdfPage
  });
  @override
  Widget build(BuildContext context) {
    if(pdfPage == null) {
      return (
        Container(
          height: 500,
          width: 500,
          color: Colors.white,
        )
      );
    } else {
      return (
          Container(
            height: pdfPage!.document!.pages[pdfPage!.pageNumber - 1].height,
            width: pdfPage!.document!.pages[pdfPage!.pageNumber - 1].width,
            child: pdfPage!,
          )
      );
    }
  }
}