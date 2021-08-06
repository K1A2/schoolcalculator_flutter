import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import '../data/DecodeScoreJson.dart';
import '../data/SchoolScoreCalculator.dart';
import '../data/SchoolScore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/SnackManager.dart';

class MainStafulPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainStafulPage();
  }
}

class _MainStafulPage extends State<MainStafulPage> with AutomaticKeepAliveClientMixin<MainStafulPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _ratioSave = "scoreratio";
  final String _switchSave = "switch";

  DecodeScoreJsonData _scoreJson;
  SchoolScoreCalculator _calculator;
  var _ratio = "1:1:1";
  var _allGrade = 0.0, _1Grade = 0.0, _2Grade = 0.0, _3Grade = 0.0;

  @override
  bool get wantKeepAlive => false;

  Future<String> getScoreRatio() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(_ratioSave) ?? "1:1:1";
  }

  Future<bool> getSwitchBool() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(_switchSave) ?? false;
  }

  getAllGradeCal() {
    _scoreJson.getAllScoreDataSemester().then((value) {
      getSwitchBool().then((value2) {
        setState(() {
          _allGrade = _calculator.getAllGrade([...value], _ratio, value2);
          final _d = _calculator.getNGrade([...value], value2);
          _1Grade = _d[0];
          _2Grade = _d[1];
          _3Grade = _d[2];
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getScoreRatio().then((value) {
      setState(() {
        _ratio = value;
      });
    });
    _scoreJson = DecodeScoreJsonData();
    _calculator = SchoolScoreCalculator();
    getAllGradeCal();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    double _cardTitleSize = 27.0;
    double _cardScoreSize = 23.0;
    double _cardScoreSize2 = 20.0;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Color(0xFF484EA9),
            expandedHeight: _size.height / 4,
            pinned: true,
            leading: IconButton(
                icon: Icon(Icons.menu_outlined),
                onPressed: () {

                }
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.settings_rounded),
                  onPressed: () {

                  }
              )
            ],
            floating: true,
            snap: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [
                          Color(0xFF484EA9),
                          Color(0xFF53256E),
                        ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "종합 성적",
                      style: TextStyle(
                          fontFamily: "SCFream",
                          fontWeight: FontWeight.w500,
                          fontSize: 35,
                          color: Colors.white
                      ),
                    ),
                    Text(
                      _allGrade.toStringAsFixed(2),
                      style: TextStyle(
                          fontFamily: "SCFream",
                          fontWeight: FontWeight.w300,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        "* 아직 입력되지 않은 학년은 가장 최근 학년 성적으로 대체됩니다.",
                        style: TextStyle(
                            fontFamily: "SCFream",
                            fontWeight: FontWeight.w200,
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "등급 반영 비율 " + _ratio,
                          style: TextStyle(
                              fontFamily: "SCFream",
                              fontWeight: FontWeight.w200,
                              fontSize: 13,
                              color: Colors.white),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            int _r1 = 1, _r2 = 1, _r3 = 1;
                            getScoreRatio().then((value) {
                              var _r = value.split(":");
                              setState(() {
                                _r1 = int.parse(_r[0]);
                                _r2 = int.parse(_r[1]);
                                _r3 = int.parse(_r[2]);
                              });
                            });
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              backgroundColor: Colors.white,
                              context: context,
                              builder: (context2) {
                                return SafeArea(
                                  child: StatefulBuilder(
                                    builder: (context3, setState3) {
                                      return Container(
                                        height: 360,
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Center(
                                              child: Text(
                                                "등급 반영 비율 변경",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w500
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 1,
                                                        child: Center(
                                                          child: Text("1학년"),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Center(
                                                          child: Text("2학년"),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Center(
                                                          child: Text("3학년"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 10),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          flex: 1,
                                                          child: Center(
                                                            child: NumberPicker(
                                                              value: _r1,
                                                              minValue: 1,
                                                              maxValue: 10,
                                                              selectedTextStyle: TextStyle(
                                                                  color: Color(0xFF53256E),
                                                                  fontSize: 20
                                                              ),
                                                              haptics: true,
                                                              onChanged: (v) {
                                                                setState3(() {
                                                                  _r1 = v;
                                                                });
                                                              },
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), topLeft: Radius.circular(20)),
                                                                  border: Border.all(color: Color(0xFF53256E))
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Center(
                                                            child: NumberPicker(
                                                              value: _r2,
                                                              minValue: 1,
                                                              maxValue: 10,
                                                              selectedTextStyle: TextStyle(
                                                                  color: Color(0xFF53256E),
                                                                  fontSize: 20
                                                              ),
                                                              haptics: true,
                                                              onChanged: (v) {
                                                                setState3(() {
                                                                  _r2 = v;
                                                                });
                                                              },
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(color: Color(0xFF53256E))
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Center(
                                                            child: NumberPicker(
                                                              value: _r3,
                                                              minValue: 1,
                                                              maxValue: 10,
                                                              selectedTextStyle: TextStyle(
                                                                  color: Color(0xFF53256E),
                                                                  fontSize: 20
                                                              ),
                                                              haptics: true,
                                                              onChanged: (v) {
                                                                setState3(() {
                                                                  _r3 = v;
                                                                });
                                                              },
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), topRight: Radius.circular(20)),
                                                                  border: Border.all(color: Color(0xFF53256E))
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 10),
                                                    child: Text(_r1.toString() + " : " + _r2.toString() + " : " + _r3.toString()),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 10),
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: OutlinedButton(
                                                        child: Text("비율 반영하기"),
                                                        onPressed: () async {
                                                          Navigator.pop(context);
                                                          var _r = _r1.toString() + ":" + _r2.toString() + ":" + _r3.toString();
                                                          SharedPreferences _prefs = await SharedPreferences.getInstance();
                                                          _prefs.setString(_ratioSave, _r);

                                                          _scoreJson.getAllScoreDataSemester().then((value) {
                                                            setState(() {
                                                              _ratio = _r;
                                                              getAllGradeCal();
                                                            });
                                                          });
                                                        },
                                                        style: OutlinedButton.styleFrom(
                                                            primary: Color(0xFF53256E)
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            );
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "종합 성적",
                              style: TextStyle(
                                  fontFamily: "SCFream",
                                  fontWeight: FontWeight.w500,
                                  fontSize: _cardTitleSize,
                                  color: Colors.black
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "전 과목 평균 등급",
                                      style: TextStyle(
                                          fontFamily: "SCFream",
                                          fontWeight: FontWeight.w300,
                                          fontSize: _cardScoreSize,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      _allGrade.toStringAsFixed(2),
                                      style: TextStyle(
                                          fontFamily: "SCFream",
                                          fontWeight: FontWeight.w300,
                                          fontSize: _cardScoreSize,
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Container(
                                height: 0.5,
                                color: Colors.black,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          "1학년\n평균 등급",
                                          style: TextStyle(
                                              fontFamily: "SCFream",
                                              fontWeight: FontWeight.w300,
                                              fontSize: _cardScoreSize2,
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(_1Grade.toStringAsFixed(2),
                                            style: TextStyle(
                                                fontFamily: "SCFream",
                                                fontWeight: FontWeight.w300,
                                                fontSize: _cardScoreSize2,
                                                color: Colors.black),
                                            textAlign: TextAlign.center)
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text("2학년\n평균 등급",
                                            style: TextStyle(
                                                fontFamily: "SCFream",
                                                fontWeight: FontWeight.w300,
                                                fontSize: _cardScoreSize2,
                                                color: Colors.black),
                                            textAlign: TextAlign.center),
                                        Text(_2Grade.toStringAsFixed(2),
                                            style: TextStyle(
                                                fontFamily: "SCFream",
                                                fontWeight: FontWeight.w300,
                                                fontSize: _cardScoreSize2,
                                                color: Colors.black),
                                            textAlign: TextAlign.center)
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text("3학년\n평균 등급",
                                            style: TextStyle(
                                                fontFamily: "SCFream",
                                                fontWeight: FontWeight.w300,
                                                fontSize: _cardScoreSize2,
                                                color: Colors.black),
                                            textAlign: TextAlign.center),
                                        Text(_3Grade.toStringAsFixed(2),
                                            style: TextStyle(
                                                fontFamily: "SCFream",
                                                fontWeight: FontWeight.w300,
                                                fontSize: _cardScoreSize2,
                                                color: Colors.black),
                                            textAlign: TextAlign.center)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "성적 분석",
                            style: TextStyle(
                                fontFamily: "SCFream",
                                fontWeight: FontWeight.w500,
                                fontSize: _cardTitleSize,
                                color: Colors.black
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ]))
        ],
      ),
    );
  }
}