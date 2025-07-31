import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_entity.freezed.dart';

@freezed
abstract class SessionEntity with _$SessionEntity {
  const factory SessionEntity({
    required String id,
    required String name,
    required int duration,
    required String color,
    required String icon,
    required String description,
  }) = _SessionEntity;
}
