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

  late DecodeScoreJsonData _scoreJson;
  late SchoolScoreCalculator _calculator;
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
            _inputData.add(BarChartRodData(toY: _data, width: 4.5, color: _typeGraphColors[j]));
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
    _gradeSemester = [];
    _typeScores = [[], [], [], [], [], []];
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

  // @override
  // void didUpdateWidget(covariant ScoreAnalyzePage oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   getAllGradeCal();
  // }

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
                                  getDrawingHorizontalLine: (value) => const FlLine(
                                    color: Colors.black12,
                                    strokeWidth: 1,
                                  ),
                                  getDrawingVerticalLine: (value) => const FlLine(
                                    color: Colors.black12,
                                    strokeWidth: 1,
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 28,
                                      getTitlesWidget: (value, meta) {
                                        String text = '';
                                        switch (value.toInt()) {
                                          case 1: text = '9등급'; break;
                                          case 3: text = '7등급'; break;
                                          case 5: text = '5등급'; break;
                                          case 7: text = '3등급'; break;
                                          case 9: text = '1등급'; break;
                                        }
                                        return SideTitleWidget(
                                          meta: meta,        // ★ axisSide → meta
                                          space: 12,         // ★ margin → space
                                          child: Text(
                                            text,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 22,
                                      getTitlesWidget: (value, meta) {
                                        String text = '';
                                        switch (value.toInt()) {
                                          case 1: text = '1-1'; break;
                                          case 2: text = '1-2'; break;
                                          case 3: text = '2-1'; break;
                                          case 4: text = '2-2'; break;
                                          case 5: text = '3-1'; break;
                                          case 6: text = '3-2'; break;
                                        }
                                        return SideTitleWidget(
                                          meta: meta,
                                          space: 8,
                                          child: Text(
                                            text,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(color: Colors.black54, width: 1),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    isCurved: true,
                                    curveSmoothness: 0.5,
                                    barWidth: 3,
                                    isStrokeCapRound: true,
                                    spots: _gradeSemester,
                                    dotData: const FlDotData(show: true),
                                    // v1.0.0: colors → color/gradient
                                    gradient: LinearGradient(colors: gradientColors),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        colors: gradientColors.map((c) => c.withOpacity(0.3)).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                                minX: 1,
                                maxX: 6,
                                minY: 1,
                                maxY: 9,
                                lineTouchData: LineTouchData(
                                  touchTooltipData: LineTouchTooltipData(
                                    getTooltipItems: (touchedSpots) {
                                      return touchedSpots.map((touchedSpot) {
                                        final bar = touchedSpot.bar;
                                        final color =
                                            bar.gradient?.colors.first ?? bar.color ?? Colors.black;
                                        return LineTooltipItem(
                                          (10 - touchedSpot.y).toStringAsFixed(2),
                                          TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        );
                                      }).toList();
                                    },
                                    // v1.0.0: tooltipBgColor → getTooltipColor
                                    getTooltipColor: (_) => Colors.black.withOpacity(0.05),
                                  ),
                                ),
                              ),
                              // v1.0.0: swapAnimationDuration/Curve → duration/curve
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.linear,
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
                                    getDrawingHorizontalLine: (value) => const FlLine(
                                      color: Colors.black12,
                                      strokeWidth: 1,
                                    ),
                                    getDrawingVerticalLine: (value) => const FlLine(
                                      color: Colors.black12,
                                      strokeWidth: 1,
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 28,
                                        getTitlesWidget: (value, meta) {
                                          String text = '';
                                          switch (value.toInt()) {
                                            case 1: text = '9등급'; break;
                                            case 3: text = '7등급'; break;
                                            case 5: text = '5등급'; break;
                                            case 7: text = '3등급'; break;
                                            case 9: text = '1등급'; break;
                                          }
                                          return SideTitleWidget(
                                            meta: meta,         // axisSide → meta
                                            space: 12,          // margin → space
                                            child: Text(
                                              text,
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 22,
                                        getTitlesWidget: (value, meta) {
                                          String text = '';
                                          switch (value.toInt()) {
                                            case 1: text = '1-1'; break;
                                            case 2: text = '1-2'; break;
                                            case 3: text = '2-1'; break;
                                            case 4: text = '2-2'; break;
                                            case 5: text = '3-1'; break;
                                            case 6: text = '3-2'; break;
                                          }
                                          return SideTitleWidget(
                                            meta: meta,
                                            space: 8,
                                            child: Text(
                                              text,
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border.all(color: Colors.black54, width: 1),
                                  ),

                                  // ⬇️ showingBarGroups도 v1 형태여야 합니다(예시는 아래 참고)
                                  barGroups: showingBarGroups,

                                  minY: 1,
                                  maxY: 9,
                                  barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                        final color =
                                            rod.gradient?.colors.first ?? rod.color ?? Colors.black;
                                        return BarTooltipItem(
                                          '${_type[rodIndex]}\n${(10 - rod.toY).toStringAsFixed(2)}',
                                          TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        );
                                      },
                                      // tooltipBgColor → getTooltipColor
                                      getTooltipColor: (_) => Colors.black.withOpacity(0.05),
                                    ),
                                  ),
                                ),
                                // swapAnimationDuration/Curve → duration/curve
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.linear,
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
                                    _typeShow[0] = v!;
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
                                    _typeShow[1] = v!;
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
                                    _typeShow[2] = v!;
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
                                    _typeShow[3] = v!;
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
                                    _typeShow[4] = v!;
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
                                    _typeShow[5] = v!;
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