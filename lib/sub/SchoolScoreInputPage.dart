import 'package:flutter/material.dart';
import '../widget/SnackManager.dart';

class SchoolScoreInputPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SchoolScoreInputPage();
  }
}

class _SchoolScoreInputPage extends State<SchoolScoreInputPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        child: Center(
          child: Text('input'),
        ),
      ),
    );
  }
}