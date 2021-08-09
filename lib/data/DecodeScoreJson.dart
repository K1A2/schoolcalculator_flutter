import 'dart:convert';
import 'SchoolScore.dart';
import 'ScoreDataIO.dart';

class DecodeScoreJsonData {
  ScoreDataIoManager _manager;

  DecodeScoreJsonData() {
    _manager = ScoreDataIoManager();
  }

  Future<List<SchoolScore>> getScoreDataSemester(String semester) async {
    var _json = await _manager.readScores(semester);
    if (_json == "error") {
      print("error");
      _json = '{"$semester": []}';
    }
    var _jsonSemeseter = jsonDecode(_json);
    List<SchoolScore> _scores = [];

    for (var j in _jsonSemeseter[semester]) {
      SchoolScore _s = SchoolScore(
          rank: int.parse(j['rank']),
          type: int.parse(j['type']),
          point: int.parse(j['point']),
          subject: j['subject']);
      _scores.add(_s);
    }

    return _scores;
  }

  Future<dynamic> getAnalyzData() async {
    final _semester = ["11", "12", "21", "22", "31", "32"];
    List<List<SchoolScore>> _datas = [];
    List<List<List<SchoolScore>>> _typeDatas = [
      [[], [], [], [], [], []],
      [[], [], [], [], [], []],
      [[], [], [], [], [], []],
      [[], [], [], [], [], []],
      [[], [], [], [], [], []],
      [[], [], [], [], [], []]];

    var _i = 0;
    for (var semester in _semester) {
      var _json = await _manager.readScores(semester);
      if (_json == "error") {
        print("error");
        _json = '{"$semester": []}';
      }
      var _jsonSemeseter = jsonDecode(_json);
      List<SchoolScore> _scores = [];

      for (var j in _jsonSemeseter[semester]) {
        SchoolScore _s = SchoolScore(
            rank: int.parse(j['rank']),
            type: int.parse(j['type']),
            point: int.parse(j['point']),
            subject: j['subject']);
        _scores.add(_s);
        _typeDatas[_i][_s.type].add(_s);
      }
      _datas.add(_scores);
      _i++;
    }

    return [_datas, _typeDatas];
  }

  Future<List<List<SchoolScore>>> getAllScoreDataSemester() async {
    final _semester = ["11", "12", "21", "22", "31", "32"];
    List<List<SchoolScore>> _datas = [];
    for (var semester in _semester) {
      var _json = await _manager.readScores(semester);
      if (_json == "error") {
        print("error");
        _json = '{"$semester": []}';
      }
      var _jsonSemeseter = jsonDecode(_json);
      List<SchoolScore> _scores = [];

      for (var j in _jsonSemeseter[semester]) {
        SchoolScore _s = SchoolScore(
            rank: int.parse(j['rank']),
            type: int.parse(j['type']),
            point: int.parse(j['point']),
            subject: j['subject']);
        _scores.add(_s);
      }
      _datas.add(_scores);
    }

    return _datas;
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
    _manager.writeScores(semester, jsonEncode({"$semester": _newList}).toString());
  }
}