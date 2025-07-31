import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timer_app/feature/home/data/models/session_model.dart';
import 'package:timer_app/feature/home/data/models/setting_model.dart';
import 'package:timer_app/feature/home/domain/entities/sessions_entity.dart';

part 'sessions_model.freezed.dart';
part 'sessions_model.g.dart';

@freezed
abstract class SessionsModel with _$SessionsModel {
  const factory SessionsModel({
    required List<SessionModel> sessions,
    required SettingModel settings,
  }) = _SessionsModel;

  factory SessionsModel.fromJson(Map<String, dynamic> json) =>
      _$SessionsModelFromJson(json);
}

extension SessionsModelExtension on SessionsModel {
  SessionsEntity toEntity() => SessionsEntity(
    sessions: sessions.map((e) => e.toEntity()).toList(),
    settings: settings.toEntity(),
  );
}
