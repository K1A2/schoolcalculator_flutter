import 'package:flutter/material.dart';
import '../widget/SnackManager.dart';

class Item {
  Item({
    @required this.code,
    @required this.scores,
    @required this.show,
    this.isExpanded = false,
  });

  String code;
  String scores;
  String show;
  bool isExpanded;
}

class SchoolScoreInputPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SchoolScoreInputPage();
  }
}

class _SchoolScoreInputPage extends State<SchoolScoreInputPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Item> _data = [];

  @override
  void initState() {
    super.initState();
    _data.add(Item(code: '11', scores: "{}", show: '1학년 1학기'));
    _data.add(Item(code: '12', scores: "{}", show: '1학년 2학기'));
    _data.add(Item(code: '21', scores: "{}", show: '2학년 1학기'));
    _data.add(Item(code: '22', scores: "{}", show: '2학년 2학기'));
    _data.add(Item(code: '31', scores: "{}", show: '3학년 1학기'));
    _data.add(Item(code: '32', scores: "{}", show: '3학년 2학기'));
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              child: ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _data[index].isExpanded = !isExpanded;
                  });
                },
                children: _data.map<ExpansionPanel>((Item item) {
                  return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(item.show),
                          subtitle: Text('2.3'),
                        );
                      },
                      body: ListTile(
                        title: Text(item.scores),
                      ),
                      isExpanded: item.isExpanded
                  );
                }).toList(),
              ),
            ),
          )
      ),
    );
  }
}