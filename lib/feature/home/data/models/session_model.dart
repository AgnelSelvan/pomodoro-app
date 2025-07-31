import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timer_app/feature/home/domain/entities/session_entity.dart';

part 'session_model.freezed.dart';
part 'session_model.g.dart';

@freezed
abstract class SessionModel with _$SessionModel {
  const factory SessionModel({
    required String id,
    required String name,
    required int duration,
    required String color,
    required String icon,
    required String description,
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
}

extension SessionModelExtension on SessionModel {
  SessionEntity toEntity() => SessionEntity(
    id: id,
    name: name,
    duration: duration ~/ 60,
    color: color,
    icon: icon,
    description: description,
  );
}
