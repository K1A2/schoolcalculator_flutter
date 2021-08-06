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
    if (grade32) {
      data = [data[0] + data[1], data[2] + data[3], data[4] + data[5]];
    } else {
      data = [data[0] + data[1], data[2] + data[3], data[4]];
    }

    List<int> zeroIndex = [];
    var lastIndex = 0;
    for (var i = 0;i < data.length;i++) {
      if (data[i].length == 0) {
        zeroIndex.add(i);
      } else {
        lastIndex = i;
      }
    }
    for (var i in zeroIndex) {
      data[i] = data[lastIndex];
    }

    var _s = 0.0;
    if (ratio == "1:1:1") {
      double _gp = 0.0;
      double _p = 0.0;
      for (var f in data) {
        for (var j in f) {
          _gp += j.point * j.rank;
          _p += j.point;
        }
      }
      _s = _gp / _p;
    } else {
      final _ratio = ratio.split(":");
      var _gradeA = 0;
      for (var f in data) {
        double _gp = 0.0;
        double _p = 0.0;
        for (var j in f) {
          _gp += j.point * j.rank;
          _p += j.point;
        }
        final _ss = _gp / _p * double.parse(_ratio[_gradeA]) / (double.parse(_ratio[0]) + double.parse(_ratio[1]) + double.parse(_ratio[2]));
        _s += _ss.isNaN ? 0 : _ss;
        _gradeA++;
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