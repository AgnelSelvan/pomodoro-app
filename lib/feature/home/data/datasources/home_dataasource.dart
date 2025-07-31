import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:timer_app/core/utils/app_file_reader.dart';
import 'package:timer_app/feature/home/data/models/sessions_model.dart';

abstract class HomeDataSource {
  Future<SessionsModel> getSessions();
}

@LazySingleton(as: HomeDataSource)
class HomeDataSourceImpl implements HomeDataSource {
  final AppFileReader _appFileReader;

  HomeDataSourceImpl({required AppFileReader appFileReader})
    : _appFileReader = appFileReader;

  @override
  Future<SessionsModel> getSessions() async {
    final json = await _appFileReader.readFile('assets/config/sessions.json');
    return SessionsModel.fromJson(jsonDecode(json));
  }
}
