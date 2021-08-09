import 'package:flutter/material.dart';
import '../data/DecodeScoreJson.dart';
import '../data/SchoolScoreCalculator.dart';
import '../data/SchoolScore.dart';
import 'package:fl_chart/fl_chart.dart';

class ScoreAnalyzePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScoreAnalyzePage();
  }
}

class _ScoreAnalyzePage extends State<ScoreAnalyzePage> with AutomaticKeepAliveClientMixin<ScoreAnalyzePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<FlSpot> _gradeSemester = [];
  List<BarChartGroupData> showingBarGroups = [];
  List<List<double>> _typeScores = [[], [], [], [], [], []];
  List<Color> _typeGraphColors = [Colors.red, Colors.blue, Colors.purple, Colors.orange, Colors.amber, Colors.green];
  List<bool> _typeShow = [true, true, true, false, false, false];
  final List<String> _type = ["국어","수학","영어","과학탐구","사회탐구","기타"];

  DecodeScoreJsonData _scoreJson;
  SchoolScoreCalculator _calculator;
  List<Color> gradientColors = [
    const Color(0xFF484EA9),
    const Color(0xFF53256E),
  ];

  setTypeGraphData() {
    showingBarGroups = [];
    setState(() {
      var _n = 1;
      for (var i in _typeScores) {
        List<BarChartRodData> _inputData = [];
        for (var j = 0;j < i.length;j++) {
          if (_typeShow[j]) {
            var _data = i[j];
            if (_data != 0) {
              _data = double.parse((10 - _data).abs().toStringAsFixed(2));
            }
            _inputData.add(BarChartRodData(y: _data, width: 4.5, colors: [_typeGraphColors[j]]));
          } else {
            continue;
          }
        }
        showingBarGroups.add(BarChartGroupData(x: _n, barRods: _inputData));
        _n++;
      }
    });
  }

  getAllGradeCal() {
    _scoreJson.getAnalyzData().then((value) {
      final _scores = value;
      setState(() {
        var _c = 1.0;
        for (var i in _scores[0]) {
          var _n = _calculator.getGrafe(i);
          if (i.length == 0) {
            _c++;
            continue;
          } else {
            var a = double.parse((10 - _n).abs().toStringAsFixed(2));
            _gradeSemester.add(FlSpot(_c, a));
            _c++;
          }
        }
      });

      var _n = 0;
      for (var i in _scores[1] as List<List<List<SchoolScore>>>) {
        for (var j in i) {
          if (j.length == 0) {
            _typeScores[_n].add(0.0);
          } else {
            _typeScores[_n].add(_calculator.getGrafe(j));
          }
        }
        _n++;
      }
      setTypeGraphData();
    });
  }

  @override
  void initState() {
    super.initState();
    _scoreJson = DecodeScoreJsonData();
    _calculator = SchoolScoreCalculator();
    getAllGradeCal();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
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
                      "종합 성적",
                      style: TextStyle(
                          fontFamily: "SCFream",
                          fontWeight: FontWeight.w500,
                          fontSize: 27,
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
                                            return '9등급';
                                          case 3:
                                            return '7등급';
                                          case 5:
                                            return '5등급';
                                          case 7:
                                            return '3등급';
                                          case 9:
                                            return '1등급';
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
                                    barWidth: 5,
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
                                                    fontWeight: FontWeight.bold),
                                              );
                                            }).toList();
                                          },
                                          tooltipBgColor: Colors.black.withOpacity(0.05)
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
                )
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
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
                        "분야별 성적",
                        style: TextStyle(
                            fontFamily: "SCFream",
                            fontWeight: FontWeight.w500,
                            fontSize: 27,
                            color: Colors.black
                        ),
                        textAlign: TextAlign.left,
                      ),
                      AspectRatio(
                          aspectRatio: 3 / 2,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                            child: Container(
                              child: BarChart(
                                BarChartData(
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
                                            return '9등급';
                                          case 3:
                                            return '7등급';
                                          case 5:
                                            return '5등급';
                                          case 7:
                                            return '3등급';
                                          case 9:
                                            return '1등급';
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
                                  barGroups: showingBarGroups,
                                  minY: 1,
                                  maxY: 9,
                                  barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      getTooltipItem:  (group, groupIndex, rod, rodIndex) {
                                        return BarTooltipItem(
                                          _type[rodIndex] + "\n" + (10 - rod.y).toStringAsFixed(2),
                                          TextStyle(
                                              color: rod.colors[0],
                                              fontWeight: FontWeight.bold),
                                        );
                                      },
                                      // tooltipBgColor: Colors.black.withOpacity(0.05)
                                    )
                                  )
                                ),
                                swapAnimationDuration: Duration(milliseconds: 500), // Optional
                                swapAnimationCurve: Curves.linear,
                              )
                            ),
                          )
                      ),
                      Container(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            SizedBox(
                              child: CheckboxListTile(
                                value: _typeShow[0],
                                contentPadding: EdgeInsets.all(0),
                                activeColor: _typeGraphColors[0],
                                onChanged: (v) {
                                  setState(() {
                                    _typeShow[0] = v;
                                  });
                                  setTypeGraphData();
                                },
                                title: Text("국어"),
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                              width: 100,
                            ),
                            SizedBox(
                              child: CheckboxListTile(
                                value: _typeShow[1],
                                activeColor: _typeGraphColors[1],
                                contentPadding: EdgeInsets.all(0),
                                onChanged: (v) {
                                  setState(() {
                                    _typeShow[1] = v;
                                  });
                                  setTypeGraphData();
                                },
                                title: Text("수학"),
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                              width: 100,
                            ),
                            SizedBox(
                              child: CheckboxListTile(
                                value: _typeShow[2],
                                activeColor: _typeGraphColors[2],
                                contentPadding: EdgeInsets.all(0),
                                onChanged: (v) {
                                  setState(() {
                                    _typeShow[2] = v;
                                  });
                                  setTypeGraphData();
                                },
                                title: Text("영어"),
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                              width: 100,
                            ),
                            SizedBox(
                              child: CheckboxListTile(
                                value: _typeShow[3],
                                activeColor: _typeGraphColors[3],
                                contentPadding: EdgeInsets.all(0),
                                onChanged: (v) {
                                  setState(() {
                                    _typeShow[3] = v;
                                  });
                                  setTypeGraphData();
                                },
                                title: Text("과학탐구"),
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                              width: 120,
                            ),
                            SizedBox(
                              child: CheckboxListTile(
                                value: _typeShow[4],
                                activeColor: _typeGraphColors[4],
                                contentPadding: EdgeInsets.all(0),
                                onChanged: (v) {
                                  setState(() {
                                    _typeShow[4] = v;
                                  });
                                  setTypeGraphData();
                                },
                                title: Text("사회탐구"),
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                              width: 120,
                            ),
                            SizedBox(
                              child: CheckboxListTile(
                                value: _typeShow[5],
                                activeColor: _typeGraphColors[5],
                                contentPadding: EdgeInsets.all(0),
                                onChanged: (v) {
                                  setState(() {
                                    _typeShow[5] = v;
                                  });
                                  setTypeGraphData();
                                },
                                title: Text("기타"),
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                              width: 100,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
              )
            ),
          ),
        ],
      )
    );
  }

  @override
  bool get wantKeepAlive => false;
}