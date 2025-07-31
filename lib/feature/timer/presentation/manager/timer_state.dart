import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timer_app/feature/home/domain/entities/session_entity.dart';

part 'timer_state.freezed.dart';

@freezed
class TimerState with _$TimerState {
  const factory TimerState.initial() = TimerStateInitial;
  const factory TimerState.loading() = TimerStateLoading;
  const factory TimerState.loaded({
    @Default(0) int remainingSeconds,
    @Default(false) bool isRunning,
    @Default(false) bool isPaused,
    SessionEntity? session,
    @Default(false) bool isExpired,
    @Default(false) bool isRestored,
  }) = TimerStateLoaded;
  const factory TimerState.error(String message) = TimerStateError;
}
