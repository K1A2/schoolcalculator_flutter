import 'dart:ffi';

import 'package:flutter/material.dart';
import '../data/DecodeScoreJson.dart';
import '../widget/SnackManager.dart';
import '../data/SchoolScore.dart';
import '../data/SchoolScoreCalculator.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Item {
  Item({
    @required this.code,
    @required this.scores,
    @required this.show,
    @required this.index,
    this.isExpanded = false,
  });

  String code;
  List<SchoolScore> scores;
  String show;
  int index;
  bool isExpanded;
}

class SchoolScoreInputPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SchoolScoreInputPage();
  }
}

class _SchoolScoreInputPage extends State<SchoolScoreInputPage> with AutomaticKeepAliveClientMixin<SchoolScoreInputPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final double _cardSize = 60.0;
  final double _cardPaddingSize = 50.0;
  final double _expandPaddingSize = 8.0;
  final double _bodySize = 50.0;

  final List<String> _type = ["국어","수학","영어","과학탐구","사회탐구","기타"];
  final List<Item> _data = [];
  final DecodeScoreJsonData _json_data = DecodeScoreJsonData();
  final subjectController = TextEditingController();
  List<ScrollController> _scrollController = [];
  bool _switch = false;
  final String _switchSave = "switch";
  final SchoolScoreCalculator _calculator = SchoolScoreCalculator();

  List<double> _calculated = [0, 0, 0, 0, 0, 0];

  Future<bool> getSwitchBool() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(_switchSave) ?? false;
  }

  initDatas() {
    final _semester = ["11", "12", "21", "22", "31", "32"];
    _json_data.getAllScoreDataSemester().then((value) {
      for (int i = 0;i < value.length;i++) {
        var _se2 = _semester[i].split("");
        _data.add(Item(code: _semester[i],
            scores: value[i],
            index: i,
            show: _se2[0] + '학년 ' + _se2[1] + '학기'));
        _calculated[i] = _calculator.getGrafe(value[i]);
      }
      setState(() {});
    });

    for (int i = 0;i < 6;i++) {
      _scrollController.add(ScrollController());
    }

    getSwitchBool().then((value) {
      setState(() {
        _switch = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initDatas();
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
                      headerBuilder: (BuildContext context1, bool isExpanded) {
                        return ListTile(
                          title: Text(item.show),
                          subtitle: Text("학기 성적: " + _calculated[item.index].toStringAsFixed(2) + " 과목: " + item.scores.length.toString() + "개"),
                        );
                      },
                      body: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Visibility(
                              visible: item.code == '32' ? true : false,
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text("3학년 2학기 포함하기"),
                                      ),
                                      Switch(
                                        value: _switch,
                                        onChanged: (bool isOn) async {
                                          setState(() {
                                            _switch = isOn;
                                          });
                                          SharedPreferences _prefs = await SharedPreferences.getInstance();
                                          _prefs.setBool(_switchSave, _switch);
                                        },
                                        activeColor: Color(0xFF652D87),
                                        activeTrackColor: Color(0xFF8743AD),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: item.code == '32' ? _switch : true,
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '과목',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '등급',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '단위',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '과목계열',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '삭제',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: item.code == '32' ? _switch : true,
                              child: Container(
                                height:  _expandPaddingSize + _cardSize * item.scores.length < _size.height / 3 ?
                                _expandPaddingSize + _cardSize * item.scores.length : _size.height / 3,
                                child: ListView.builder(
                                  controller: _scrollController[item.index],
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
                                                  child: Padding(
                                                    padding: EdgeInsets.only(right: 5),
                                                    child: OutlinedButton(
                                                      child: Text(
                                                        item.scores[index2].subject,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      style: OutlinedButton.styleFrom(
                                                        primary: Color(0xFF53256E),
                                                      ),
                                                      onPressed: () async {
                                                        subjectController.text = item.scores[index2].subject;
                                                        FocusNode _focusNode = new FocusNode();

                                                        String reslut = await showDialog(
                                                            context: context,
                                                            builder: (BuildContext buildcontext) {
                                                              return StatefulBuilder(
                                                                builder: (context4, setState2) {
                                                                  void _onSubjectFocusChange() {
                                                                    //Force updated once if focus changed
                                                                    setState2(() {});
                                                                  }
                                                                  _focusNode.addListener(_onSubjectFocusChange);
                                                                  return AlertDialog(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                                                                    ),
                                                                    title: Text('과목명 변경'),
                                                                    content: TextField(
                                                                      focusNode: _focusNode,
                                                                      controller: subjectController,
                                                                      cursorColor: Color(
                                                                          0xFF6D3393),
                                                                      decoration: InputDecoration(
                                                                          border: OutlineInputBorder(),
                                                                          labelText: '과목명',
                                                                          labelStyle: TextStyle(
                                                                            color: _focusNode.hasFocus ? Color(0xFF53256E) : Colors.grey,
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderSide: BorderSide(color: Color(0xFF53256E)),
                                                                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                                                                          ),
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                                            borderSide: BorderSide(color: Colors.grey),
                                                                          )
                                                                      ),
                                                                    ),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          Navigator.pop(context, 'Cancel');
                                                                          _focusNode.removeListener(_onSubjectFocusChange);
                                                                        },
                                                                        child: const Text('취소'),
                                                                        style: TextButton.styleFrom(
                                                                            primary: Colors.red
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          Navigator.pop(context, 'OK');
                                                                          String _sub = subjectController.text;
                                                                          if (_sub.isNotEmpty) {
                                                                            setState(() {
                                                                              item.scores[index2].subject = subjectController.text;
                                                                            });
                                                                            _json_data.changeSemesterData(item.code, item.scores);
                                                                          } else {
                                                                            SnackBarManager.showSnackBar(context, "빈 칸 입니다.", "확인", Duration(milliseconds: 1000), Colors.red);
                                                                          }
                                                                          _focusNode.removeListener(_onSubjectFocusChange);
                                                                        },
                                                                        child: const Text('저장'),
                                                                        style: TextButton.styleFrom(
                                                                            primary: Colors.blue
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            }
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(right: 5, left: 5),
                                                    child: OutlinedButton(
                                                      child: Text(item.scores[index2].rank.toString()),
                                                      style: OutlinedButton.styleFrom(
                                                        primary: Color(0xFF53256E),
                                                      ),
                                                      onPressed: () async {
                                                        var _rank = item.scores[index2].rank;

                                                        String reslut = await showDialog(
                                                            context: context,
                                                            builder: (BuildContext buildcontext) {
                                                              return StatefulBuilder(
                                                                builder: (context4, setState2) {
                                                                  return AlertDialog(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                                                                    ),
                                                                    title: Text('과목 등급 변경'),
                                                                    content: NumberPicker(
                                                                      minValue: 1,
                                                                      maxValue: 9,
                                                                      value: _rank,
                                                                      haptics: true,
                                                                      selectedTextStyle: TextStyle(
                                                                          color: Color(0xFF53256E),
                                                                          fontSize: 20
                                                                      ),
                                                                      axis: Axis.vertical,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(16),
                                                                          border: Border.all(color: Color(0xFF53256E))
                                                                      ),
                                                                      onChanged: (v) {
                                                                        setState2(() {
                                                                          _rank = v;
                                                                        });
                                                                      },
                                                                    ),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed: () => Navigator.pop(context, 'Cancel'),
                                                                        child: const Text('취소'),
                                                                        style: TextButton.styleFrom(
                                                                            primary: Colors.red
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          Navigator.pop(context, 'OK');
                                                                          setState(() {
                                                                            item.scores[index2].rank = _rank;
                                                                            _calculated[item.index] = _calculator.getGrafe(item.scores);
                                                                          });
                                                                          _json_data.changeSemesterData(item.code, item.scores);
                                                                        },
                                                                        child: const Text('저장'),
                                                                        style: TextButton.styleFrom(
                                                                            primary: Colors.blue
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            }
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(right: 5, left: 5),
                                                    child: OutlinedButton(
                                                      child: Text(item.scores[index2].point.toString()),
                                                      style: OutlinedButton.styleFrom(
                                                        primary: Color(0xFF53256E),
                                                      ),
                                                      onPressed: () async {
                                                        var _point = item.scores[index2].point;

                                                        String reslut = await showDialog(
                                                            context: context,
                                                            builder: (BuildContext buildcontext) {
                                                              return StatefulBuilder(
                                                                builder: (context4, setState2) {
                                                                  return AlertDialog(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                                                                    ),
                                                                    title: Text('과목 단위 변경'),
                                                                    content: NumberPicker(
                                                                      minValue: 1,
                                                                      maxValue: 9,
                                                                      value: _point,
                                                                      selectedTextStyle: TextStyle(
                                                                          color: Color(0xFF53256E),
                                                                          fontSize: 20
                                                                      ),
                                                                      haptics: true,
                                                                      axis: Axis.vertical,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(16),
                                                                          border: Border.all(color: Color(0xFF53256E))
                                                                      ),
                                                                      onChanged: (v) {
                                                                        setState2(() {
                                                                          _point = v;
                                                                        });
                                                                      },
                                                                    ),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed: () => Navigator.pop(context, 'Cancel'),
                                                                        child: const Text('취소'),
                                                                        style: TextButton.styleFrom(
                                                                            primary: Colors.red
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          Navigator.pop(context, 'OK');
                                                                          setState(() {
                                                                            item.scores[index2].point = _point;
                                                                            _calculated[item.index] = _calculator.getGrafe(item.scores);
                                                                          });
                                                                          _json_data.changeSemesterData(item.code, item.scores);
                                                                        },
                                                                        child: const Text('저장'),
                                                                        style: TextButton.styleFrom(
                                                                            primary: Colors.blue
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            }
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(right: 5, left: 5),
                                                    child: OutlinedButton(
                                                      child: Text(_type[item.scores[index2].type]),
                                                      style: OutlinedButton.styleFrom(
                                                        primary: Color(0xFF53256E),
                                                      ),
                                                      onPressed: () async {
                                                        var _typeNumeric = item.scores[index2].type;

                                                        String reslut = await showDialog(
                                                            context: context,
                                                            builder: (BuildContext buildcontext) {
                                                              return StatefulBuilder(
                                                                builder: (context4, setState2) {
                                                                  return AlertDialog(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                                                                    ),
                                                                    title: Text('과목 계열 변경'),
                                                                    content: NumberPicker(
                                                                      minValue: 0,
                                                                      maxValue: 5,
                                                                      value: _typeNumeric,
                                                                      selectedTextStyle: TextStyle(
                                                                          color: Color(0xFF53256E),
                                                                          fontSize: 20
                                                                      ),
                                                                      haptics: true,
                                                                      textMapper: (s) {
                                                                        return _type[int.parse(s)];
                                                                      },
                                                                      axis: Axis.vertical,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(16),
                                                                          border: Border.all(color: Color(0xFF53256E))
                                                                      ),
                                                                      onChanged: (v) {
                                                                        setState2(() {
                                                                          _typeNumeric = v;
                                                                        });
                                                                      },
                                                                    ),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed: () => Navigator.pop(context, 'Cancel'),
                                                                        child: const Text('취소'),
                                                                        style: TextButton.styleFrom(
                                                                            primary: Colors.red
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          Navigator.pop(context, 'OK');
                                                                          setState(() {
                                                                            item.scores[index2].type = _typeNumeric;
                                                                          });
                                                                          _json_data.changeSemesterData(item.code, item.scores);
                                                                        },
                                                                        child: const Text('저장'),
                                                                        style: TextButton.styleFrom(
                                                                            primary: Colors.blue
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            }
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(left: 5),
                                                    child: IconButton(
                                                      padding: EdgeInsets.all(0),
                                                      icon: Icon(
                                                        Icons.delete_rounded,
                                                        color: Color(0xFF53256E),
                                                      ),
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
                            ),
                            Visibility(
                              visible: item.code == '32' ? _switch : true,
                              child: Container(
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
                                        setState(() {
                                          SchoolScore value = SchoolScore(rank: 1, type: 0, point: 1, subject: "국어");
                                          item.scores.add(value);
                                          _calculated[item.index] = _calculator.getGrafe(item.scores);
                                          var _scroll = _scrollController[item.index];
                                          _scroll.animateTo(_scroll.position.maxScrollExtent + _cardSize, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                        });
                                        _json_data.changeSemesterData(item.code, item.scores);
                                      },
                                    ),
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => false;
}