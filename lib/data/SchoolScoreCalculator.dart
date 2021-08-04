import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';
import 'SchoolScore.dart';

class SchoolScoreCalculator {


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