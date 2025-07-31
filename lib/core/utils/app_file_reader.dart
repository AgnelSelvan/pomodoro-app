import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppFileReader {
  Future<String> readFile(String path) async {
    return await rootBundle.loadString(path);
  }
}
