import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';
import 'SchoolScore.dart';

class SchoolScoreCalculator {

  List<double> getNGrade(List<List<SchoolScore>> data, bool grade32) {
    if (grade32) {
      data = [data[0] + data[1], data[2] + data[3], data[4] + data[5]];
    } else {
      data = [data[0] + data[1], data[2] + data[3], data[4]];
    }

    List<double> _r = [];
    for (var f in data) {
      double _gp = 0.0;
      double _p = 0.0;
      for (var j in f) {
        _gp += j.point * j.rank;
        _p += j.point;
      }

      var _s = _gp / _p;
      if (_s.isNaN) {
        _s = 0;
      }
      _r.add(_s);
    }

    return _r;
  }

  double getAllGrade(List<List<SchoolScore>> data, String ratio, bool grade32) {
    var _s = 0.0;

    List<int> zeroIndex = [];
    var lastIndex = 0;
    for (var i = 0;i < (grade32 ? data.length : 5);i++) {
      if (data[i].length == 0) {
        zeroIndex.add(i);
      } else {
        lastIndex = i;
      }
    }
    for (var i in zeroIndex) {
      data[i] = data[lastIndex];
    }

    if (ratio == "1:1:1") {
      double _gp = 0.0;
      double _p = 0.0;
      var _a = 0;
      for (var f in data) {
        for (var j in f) {
          if (_a == 5 && !grade32) {
            continue;
          }
          _gp += j.point * j.rank;
          _p += j.point;
        }
        _a += 1;
      }
      _s = _gp / _p;
    } else {
      int _grade = 0;
      int _gradeA = -1;
      final _ratio = ratio.split(":");
      for (var f in data) {
        double _gp = 0.0;
        double _p = 0.0;
        for (var j in f) {
          if (_grade == 5 && !grade32) {
            print("sss");
            continue;
          }
          _gp += j.point * j.rank;
          _p += j.point;
        }
        if (_grade % 2 == 0) _gradeA += 1;
        final _ss = _gp / _p * double.parse(_ratio[_gradeA]) / (double.parse(_ratio[0]) + double.parse(_ratio[1]) + double.parse(_ratio[2]));
        _s += _ss.isNaN ? 0 : _ss;
        _grade += 1;
      }
    }

    if (_s.isNaN) {
      return 0;
    } else {
      return _s;
    }
  }

  double getGrafe(List<SchoolScore> data) {
    if (data.length == 0) {
      return 0;
    } else {
      int _rankAndPoit = 0;
      int _poit = 0;
      for (var i in data) {
        _poit += i.point;
        _rankAndPoit += i.rank * i.point;
      }
      return _rankAndPoit / _poit;
    }
  }
}