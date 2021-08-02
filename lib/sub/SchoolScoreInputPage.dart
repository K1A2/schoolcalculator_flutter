import 'package:flutter/material.dart';
import '../data/DecodeScoreJson.dart';
import '../widget/SnackManager.dart';
import '../data/SchoolScore.dart';

class Item {
  Item({
    @required this.code,
    @required this.scores,
    @required this.show,
    this.isExpanded = false,
  });

  String code;
  List<SchoolScore> scores;
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
  final double _cardSize = 50.0;
  final double _cardPaddingSize = 50.0;
  final double _expandPaddingSize = 8.0;
  final double _bodySize = 50.0;

  final List<Item> _data = [];
  final DecodeScoreJsonData _json_data = DecodeScoreJsonData("");

  @override
  void initState() {
    super.initState();
    _data.add(Item(code: '11', scores: _json_data.getScoreDataSemester('11'), show: '1학년 1학기'));
    _data.add(Item(code: '12', scores: _json_data.getScoreDataSemester('12'), show: '1학년 2학기'));
    _data.add(Item(code: '21', scores: _json_data.getScoreDataSemester('21'), show: '2학년 1학기'));
    _data.add(Item(code: '22', scores: _json_data.getScoreDataSemester('22'), show: '2학년 2학기'));
    _data.add(Item(code: '31', scores: _json_data.getScoreDataSemester('31'), show: '3학년 1학기'));
    _data.add(Item(code: '32', scores: _json_data.getScoreDataSemester('32'), show: '3학년 2학기'));
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
                      body: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Text('과목'),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text('등급'),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text('단위'),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('과목계열'),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text('삭제'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height:  _expandPaddingSize + _cardSize * item.scores.length < _size.height / 3 ?
                              _expandPaddingSize + _cardSize * item.scores.length : _size.height / 3,
                              child: ListView.builder(
                                padding: EdgeInsets.all(_expandPaddingSize),
                                itemCount: item.scores.length,
                                itemBuilder: (BuildContext context2, int index2) {
                                  return Container(
                                    height: _cardSize,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Center(
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: Text(item.scores[index2].subject),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(item.scores[index2].rank.toString()),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(item.scores[index2].point.toString()),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(item.scores[index2].type.toString()),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: IconButton(
                                                  padding: EdgeInsets.all(0),
                                                  icon: Icon(Icons.delete_rounded),
                                                  onPressed: () {
                                                    SnackBarManager.showSnackBar(
                                                        context,
                                                        item.scores[index2].subject + ' 삭제', '확인',
                                                        Duration(milliseconds: 1500), Colors.red
                                                    );
                                                    setState(() {
                                                      item.scores.removeAt(index2);
                                                    });
                                                    _json_data.changeSemesterData(item.code, item.scores);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    icon: Icon(Icons.add_rounded),
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF53256E)
                                    ),
                                    label: Text('과목 추가하기'),
                                    onPressed: () {

                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
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