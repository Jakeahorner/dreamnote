import 'package:dreamnote/src/Editor/Background.dart';
import 'package:dreamnote/src/Editor/Editor.dart';
import 'package:flutter/widgets.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return (
        Background(
        child: Editor(),
      )
    );
  }
}