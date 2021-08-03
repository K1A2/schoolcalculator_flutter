import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ScoreDataIoManager {
  Future<File> _filePath(String code) async {
    final directory = await getApplicationDocumentsDirectory();
    return File(join(directory.path, code));
  }

  Future<File> writeScores(String code, String json) async {
    final file = await _filePath(code);
    return file.writeAsString(json);
  }

  Future<String> readScores(String code) async {
    try {
      final file = await _filePath(code);
      if (await file.exists()) {
        String contents = await file.readAsString();
        return contents;
      } else {
        writeScores(code, '{"$code": []}');
        return '{"$code": []}';
      }
    } catch (e) {
      // 에러가 발생할 경우 0을 반환.
      return "error";
    }
  }
}