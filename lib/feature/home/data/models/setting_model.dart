import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timer_app/feature/home/domain/entities/setting_entity.dart';

part 'setting_model.freezed.dart';
part 'setting_model.g.dart';

@freezed
abstract class SettingModel with _$SettingModel {
  const factory SettingModel({
    @JsonKey(name: 'inactivity_threshold') required int inactivityThreshold,
    @JsonKey(name: 'auto_skip_breaks') required bool autoSkipBreaks,
    @JsonKey(name: 'sound_enabled') required bool soundEnabled,
    @JsonKey(name: 'vibration_enabled') required bool vibrationEnabled,
  }) = _SettingModel;

  factory SettingModel.fromJson(Map<String, dynamic> json) =>
      _$SettingModelFromJson(json);
}

extension SettingModelExtension on SettingModel {
  SettingEntity toEntity() => SettingEntity(
    inactivityThreshold: inactivityThreshold,
    autoSkipBreaks: autoSkipBreaks,
    soundEnabled: soundEnabled,
    vibrationEnabled: vibrationEnabled,
  );
}
