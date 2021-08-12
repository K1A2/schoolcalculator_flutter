import 'package:flutter/material.dart';
import 'sub/MainPage.dart';
import 'sub/SchoolScoreInputPage.dart';
import 'sub/ScoreAnalyzePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyaAppPage(),
      theme: ThemeData(
        fontFamily: "SCDream",
        primaryColor: Color(0xFF53256E)
      ),
    );
  }
}

class MyaAppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyaAppPage();
  }
}

class _MyaAppPage extends State<MyaAppPage> with SingleTickerProviderStateMixin {
  late TabController controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() {
      setState(() {
        _selectedIndex = controller.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        children: <Widget>[
          MainStafulPage(),
          SchoolScoreInputPage(),
          ScoreAnalyzePage()
        ],
        controller: controller,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF53256E),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: '메인화면',
            icon: Icon(Icons.home_rounded)
          ),
          BottomNavigationBarItem(
            label: '학교 성적입력',
            icon: Icon(Icons.edit_rounded)
          ),
          BottomNavigationBarItem(
            label: '성적 분석',
            icon: Icon(Icons.bar_chart_rounded)
          ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            controller.index = _selectedIndex;
          });
        },
      )
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}