import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timer_app/feature/home/domain/entities/session_entity.dart';
import 'package:timer_app/feature/home/domain/entities/setting_entity.dart';

part 'sessions_entity.freezed.dart';

@freezed
abstract class SessionsEntity with _$SessionsEntity {
  const factory SessionsEntity({
    required List<SessionEntity> sessions,
    required SettingEntity settings,
  }) = _SessionsEntity;
}
