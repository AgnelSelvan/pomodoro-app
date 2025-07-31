import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_entity.freezed.dart';

@freezed
abstract class SettingEntity with _$SettingEntity {
  const factory SettingEntity({
    required int inactivityThreshold,
    required bool autoSkipBreaks,
    required bool soundEnabled,
    required bool vibrationEnabled,
  }) = _SettingEntity;
}
