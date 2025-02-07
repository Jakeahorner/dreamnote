import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return(
    ColoredBox(
      color: Colors.grey,
        child: InteractiveViewer(

          child: SizedBox(
        height: 500,
        width: 200,
            child: child,
        ),
      )
    )

    );
  }
}