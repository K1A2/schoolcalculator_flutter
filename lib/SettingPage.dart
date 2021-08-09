import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingPage();
  }
}

class _SettingPage extends State<SettingPage> {
  final String _switchSave = "switch";
  var _isShow = false;

  Future<bool> getSwitchBool() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(_switchSave) ?? false;
  }

  @override
  void initState() {
    super.initState();
    getSwitchBool().then((value) {
      setState(() {
        _isShow = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS ? AppBar(title: Text('두 번째')) : null,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "성적 설정",
                    style: TextStyle(
                      color: Color(0xFF652D87),
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0, top: 10, right: 0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("3학년 2학기 성적 포함하기", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),),
                              Text(_isShow ? "3학년 2학기 성적을 포함합니다." : "3학년 2학기 성적을 포함하지 않습니다."),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isShow,
                          activeColor: Color(0xFF652D87),
                          onChanged: (v) async {
                            setState(() {
                              _isShow = v;
                            });
                            SharedPreferences _prefs = await SharedPreferences.getInstance();
                            _prefs.setBool(_switchSave, _isShow);
                          },
                        )
                      ],
                    )
                  ),
                ],
              ),
            ),
          ],
        )
      )
    );
  }
}