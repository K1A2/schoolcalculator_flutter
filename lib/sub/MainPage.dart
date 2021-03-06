import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:numberpicker/numberpicker.dart';
import '../data/DecodeScoreJson.dart';
import '../data/SchoolScoreCalculator.dart';
import '../SettingPage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
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

  late DecodeScoreJsonData _scoreJson;
  late SchoolScoreCalculator _calculator;
  var _ratio = "1:1:1";
  var _allGrade = 0.0, _1Grade = 0.0, _2Grade = 0.0, _3Grade = 0.0;
  List<FlSpot> _gradeSemester = [];
  List<List<double>> _gradeSemesterNum = [];
  List<Color> gradientColors = [
    const Color(0xFF484EA9),
    const Color(0xFF53256E),
  ];

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
      _gradeSemester = [];
      getSwitchBool().then((value2) {
        if (mounted) {
          setState(() {
            _allGrade = _calculator.getAllGrade([...value], _ratio, value2);
            final _d = _calculator.getNGrade([...value], value2);
            _1Grade = _d[0];
            _2Grade = _d[1];
            _3Grade = _d[2];

            var _c = 1.0;
            List<double> _l = [];
            for (var i in [...value]) {
              var _n = _calculator.getGrafe(i);
              _l.add(_n);
              if (_c == 6.0 && !value2) continue;
              if (i.length == 0) {
                _c++;
                continue;
              } else {
                var a = double.parse((10 - _n).abs().toStringAsFixed(2));
                _gradeSemester.add(FlSpot(_c, a));
                _c++;
              }
            }
            _gradeSemesterNum = [[_l[0], _l[1]], [_l[2], _l[3]], [_l[4], _l[5]]];
          });
        }
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
  void didUpdateWidget(covariant MainStafulPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    getAllGradeCal();
  }


  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    double _cardTitleSize = 25.0;
    double _cardScoreSize = 20.0;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Color(0xFF484EA9),
            expandedHeight: _size.height / 4,
            pinned: true,
            leading: IconButton(
                icon: Icon(Icons.menu_rounded),
                onPressed: () {
                  SnackBarManager.showSnackBar(context, "??? ????????? ?????? ???????????? ??? ???????????????.", "??????", Duration(seconds: 2), Colors.blue);
                }
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.settings_rounded),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context2) => SettingPage()));
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
                        colors: gradientColors
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "?????? ??????",
                      style: TextStyle(
                          fontFamily: "SCDream",
                          fontWeight: FontWeight.w500,
                          fontSize: 27,
                          color: Colors.white
                      ),
                    ),
                    Text(
                      _allGrade.toStringAsFixed(2),
                      style: TextStyle(
                          fontFamily: "SCDream",
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                          color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        "* ?????? ???????????? ?????? ????????? ?????? ?????? ?????? ???????????? ???????????????.",
                        style: TextStyle(
                            fontFamily: "SCDream",
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
                          "?????? ?????? ?????? " + _ratio,
                          style: TextStyle(
                              fontFamily: "SCDream",
                              fontWeight: FontWeight.w200,
                              fontSize: 12,
                              color: Colors.white),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_rounded, color: Colors.white,),
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
                                                "?????? ?????? ?????? ??????",
                                                style: TextStyle(
                                                    fontSize: 20,
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
                                                          child: Text("1??????"),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Center(
                                                          child: Text("2??????"),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Center(
                                                          child: Text("3??????"),
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
                                                        child: Text("?????? ????????????"),
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
                              "?????? ??????",
                              style: TextStyle(
                                  fontFamily: "SCDream",
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
                                      "??? ?????? ?????? ??????",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: _cardScoreSize,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      _allGrade.toStringAsFixed(2),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: _cardScoreSize,
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            Row(
                              children: [
                                _topCardScores(1, _1Grade),
                                _topCardScores(2, _2Grade),
                                _topCardScores(3, _3Grade),
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
                            "?????? ??????",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: _cardTitleSize,
                                color: Colors.black
                            ),
                            textAlign: TextAlign.left,
                          ),
                          AspectRatio(
                            aspectRatio: 3 / 2,
                            child: Padding(
                              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                              child: Container(
                                child: LineChart(
                                  LineChartData(
                                      gridData: FlGridData(
                                          getDrawingHorizontalLine: (value) {
                                            return FlLine(
                                                color: Colors.black12,
                                                strokeWidth: 1
                                            );
                                          },
                                          getDrawingVerticalLine: (value) {
                                            return FlLine(
                                              color: Color(0xff37434d),
                                              strokeWidth: 5,
                                            );
                                          }
                                      ),
                                      titlesData: FlTitlesData(
                                        show: true,
                                        leftTitles: SideTitles(
                                          showTitles: true,
                                          getTextStyles: (style) {
                                            return TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            );
                                          },
                                          getTitles: (value) {
                                            switch (value.toInt()) {
                                              case 1:
                                                return '9??????';
                                              case 3:
                                                return '7??????';
                                              case 5:
                                                return '5??????';
                                              case 7:
                                                return '3??????';
                                              case 9:
                                                return '1??????';
                                            }
                                            return '';
                                          },
                                          reservedSize: 28,
                                          margin: 12,
                                        ),
                                        bottomTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 22,
                                          getTextStyles: (v) {
                                            return TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12
                                            );
                                          },
                                          getTitles: (value) {
                                            switch (value.toInt()) {
                                              case 1:
                                                return '1-1';
                                              case 2:
                                                return '1-2';
                                              case 3:
                                                return '2-1';
                                              case 4:
                                                return '2-2';
                                              case 5:
                                                return '3-1';
                                              case 6:
                                                return '3-2';
                                            }
                                            return '';
                                          },
                                          margin: 8,
                                        ),
                                      ),
                                      borderData: FlBorderData(
                                        show: true,
                                        border: Border.all(color: Colors.black54, width: 1),
                                      ),
                                      lineBarsData: [LineChartBarData(
                                        isCurved: true,
                                        barWidth: 3,
                                        isStrokeCapRound: true,
                                        spots: _gradeSemester,
                                        dotData: FlDotData(
                                          show: true,
                                        ),
                                        colors: gradientColors,
                                        belowBarData: BarAreaData(
                                          show: true,
                                          colors: gradientColors.map((color) => color.withOpacity(0.3)).toList()
                                        ),
                                        curveSmoothness: 0.5,
                                      )],
                                      minX: 1,
                                      maxX: 6,
                                      minY: 1,
                                      maxY: 9,
                                    lineTouchData: LineTouchData(
                                      touchTooltipData: LineTouchTooltipData(
                                        getTooltipItems: (touchedSpots) {
                                          return touchedSpots.map((touchedSpot) {
                                            return LineTooltipItem(
                                                (10 - touchedSpot.y).toStringAsFixed(2),
                                                TextStyle(
                                                  color: touchedSpot.bar.colors[0],
                                                  fontWeight: FontWeight.bold,
                                                    fontSize: 18
                                                ),
                                            );
                                          }).toList();
                                        },
                                        // tooltipBgColor: Colors.black.withOpacity(0.05)
                                      )
                                    )
                                  ),
                                  swapAnimationDuration: Duration(milliseconds: 500), // Optional
                                  swapAnimationCurve: Curves.linear,
                                ),
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  // padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  padding: EdgeInsets.zero,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 130.0,
                      autoPlay: true,
                      viewportFraction: 0.9,
                      autoPlayInterval: Duration(seconds: 3),
                    ),
                    items: _gradeSemesterNum.map((i) {
                      return Builder(
                          builder: (context1) {
                            return Container(
                              width: _size.width - 10,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                       (_gradeSemesterNum.indexOf(i) + 1).toString() + "?????? ??????",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: _cardTitleSize - 5,
                                            color: Colors.black
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Container(
                                            child: Row(
                                              children: <Widget>[
                                                _pageBottomLayout(1, i[0]),
                                                VerticalDivider(
                                                  color: Colors.black,
                                                ),
                                                _pageBottomLayout(2, i[1]),
                                              ],
                                            ),
                                          ),
                                        )
                                      )
                                    ],
                                  ),
                                )
                              ),
                            );
                          }
                      );
                    }).toList(),
                  )
                )
              ]))
        ],
      ),
    );
  }

  Expanded _topCardScores(int n, double score) {
    return Expanded(
      flex: 1,
      child: Center(
        child: Column(
          children: [
            Text(
              "$n??????\n?????? ??????",
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Text(score.toStringAsFixed(2),
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                    color: Colors.black),
                textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }

  Expanded _pageBottomLayout(int n, double score) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Align(
              child: Text(
                "$n??????",
                style: TextStyle(
                    // fontSize: 20
                ),
              ),
              alignment: Alignment.bottomCenter,
            ),
          ),
          Expanded(
            child: Text(
              score.toStringAsFixed(2),
              style: TextStyle(
                  // fontSize: 18
              ),
            ),
          )
        ],
      ),
    );
  }
}