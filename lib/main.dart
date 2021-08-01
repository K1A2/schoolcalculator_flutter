import 'package:flutter/material.dart';
import 'widget/SnackManager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainStafulPage(),
    );
  }
}

class MainStafulPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainStafulPage();
  }
}

class _MainStafulPage extends State<MainStafulPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
                      "3.78",
                      style: TextStyle(
                          fontFamily: "SCFream",
                          fontWeight: FontWeight.w300,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        "* 아직 입력되지 않은 학기 가장 최근 학기 성적으로 대체됩니다.",
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
                          "등급 반영 비율 1:1:1",
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
                            SnackBarManager.showSnackBar(context, "비율 조정 클릭", "확인");
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
                              "3.78",
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
                                Text("3.78",
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
                                Text("3.78",
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
                                Text("3.78",
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
            )
          ]))
        ],
      ),
    );
  }
}