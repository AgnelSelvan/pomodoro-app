import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer_state_entity.freezed.dart';

@freezed
abstract class TimerStateEntity with _$TimerStateEntity {
  factory TimerStateEntity({
    required String sessionId,
    required int remainingSeconds,
    required bool isRunning,
    required bool isPaused,
    required int startTime,
  }) = _TimerStateEntity;

  TimerStateEntity._();

  bool get isExpired => remainingSeconds <= 0;
}
