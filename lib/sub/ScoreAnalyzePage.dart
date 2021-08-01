import 'package:flutter/material.dart';
import '../widget/SnackManager.dart';

class ScoreAnalyzePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScoreAnalyzePage();
  }
}

class _ScoreAnalyzePage extends State<ScoreAnalyzePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        child: Center(
          child: Text('analyze'),
        ),
      ),
    );
  }
}