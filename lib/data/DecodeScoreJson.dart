import 'dart:convert';
import 'SchoolScore.dart';

class DecodeScoreJsonData {
  final _socreData = '''{"11": [
        {"rank": "4","type": "4","point": "3","subject": "한국사"},
        {"rank": "5","type": "0","point": "4","subject": "국어"},
        {"rank": "2","type": "1","point": "4","subject": "수학"},
        {"rank": "5","type": "2","point": "4","subject": "영어"},
        {"rank": "5","type": "4","point": "4","subject": "통합사회"},
        {"rank": "5","type": "3","point": "3","subject": "통합과학"},
        {"rank": "5","type": "3","point": "1","subject": "과학탐구실험"}
    ],
    "12": [
        {"rank": "4","type": "0","point": "4","subject": "국어"},
        {"rank": "5","type": "2","point": "4","subject": "영어"},
        {"rank": "2","type": "1","point": "4","subject": "수학"},
        {"rank": "4","type": "4","point": "3","subject": "한국사"},
        {"rank": "3","type": "4","point": "4","subject": "통합사회"},
        {"rank": "3","type": "3","point": "3","subject": "통합과학"}
    ],
    "21": [
        {"rank": "6","type": "0","point": "4","subject": "국어"},
        {"rank": "2","type": "1","point": "4","subject": "수학"},
        {"rank": "5","type": "2","point": "4","subject": "영어"},
        {"rank": "4","type": "3","point": "3","subject": "물리학I"},
        {"rank": "3","type": "3","point": "3","subject": "화학I"},
        {"rank": "1","type": "3","point": "3","subject": "지구과학I"},
        {"rank": "4","type": "1","point": "2","subject": "기하"}
    ],
    "22": [
        {"rank": "4","type": "0","point": "4","subject": "국어"},
        {"rank": "3","type": "1","point": "4","subject": "수학"},
        {"rank": "3","type": "1","point": "2","subject": "기하"},
        {"rank": "3","type": "3","point": "3","subject": "물리학I"},
        {"rank": "3","type": "3","point": "3","subject": "화학I"},
        {"rank": "3","type": "3","point": "3","subject": "지구과학I"},
        {"rank": "5","type": "2","point": "4","subject": "영어"}
    ],
    "31": [
        {"rank": "5","type": "0","point": "4","subject": "언어와 매채"},
        {"rank": "4","type": "1","point": "3","subject": "미적분"},
        {"rank": "4","type": "1","point": "2","subject": "확률과 통계"},
        {"rank": "5","type": "2","point": "4","subject": "영어"},
        {"rank": "4","type": "3","point": "4","subject": "물리"},
        {"rank": "3","type": "3","point": "4","subject": "지구"},
        {"rank": "5","type": "2","point": "2","subject": "심영독"},
        {"rank": "3","type": "4","point": "2","subject": "여행지리"},
        {"rank": "1","type": "5","point": "3","subject": "정보"}
    ],
    "32": []}''';
  var _json;

  DecodeScoreJsonData(String json) {
    this._json = jsonDecode(_socreData);
  }

  List<SchoolScore> getScoreDataSemester(String semester) {
    var _jsonSemeseter = _json[semester];
    List<SchoolScore> _scores = [];

    for (var j in _jsonSemeseter) {
      SchoolScore _s = SchoolScore(
          rank: int.parse(j['rank']),
          type: int.parse(j['type']),
          point: int.parse(j['point']),
          subject: j['subject']);
      _scores.add(_s);
    }
    
    return _scores;
  }

  changeSemesterData(String semester, List<SchoolScore> list) {
    List _newList = [];
    for (var i in list) {
      int _rank = i.rank;
      int _type = i.type;
      int _point = i.point;
      String _subject = i.subject;
      _newList.add({"rank": "$_rank", "type": "$_type", "point": "$_point", "subject": "$_subject"});
    }
    _json[semester] = _newList;
    // print(jsonEncode(_json).toString());
  }
}