import 'package:flutter/foundation.dart';

class SchoolScore {
  SchoolScore({
    @required this.rank,
    @required this.type,
    @required this.point,
    @required this.subject,
  });

  int rank;
  int type;
  int point;
  String subject;
}