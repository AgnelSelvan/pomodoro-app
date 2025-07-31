import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timer_app/feature/timer/domain/entities/timer_state_entity.dart';

part 'timer_state_model.freezed.dart';
part 'timer_state_model.g.dart';

@freezed
abstract class TimerStateModel with _$TimerStateModel {
  const factory TimerStateModel({
    required String sessionId,
    required int remainingSeconds,
    required bool isRunning,
    required bool isPaused,
    required int startTime,
  }) = _TimerStateModel;

  factory TimerStateModel.fromJson(Map<String, dynamic> json) =>
      _$TimerStateModelFromJson(json);
}

extension X on TimerStateModel {
  TimerStateEntity toEntity() {
    return TimerStateEntity(
      sessionId: sessionId,
      remainingSeconds: remainingSeconds,
      isRunning: isRunning,
      isPaused: isPaused,
      startTime: startTime,
    );
  }
}
