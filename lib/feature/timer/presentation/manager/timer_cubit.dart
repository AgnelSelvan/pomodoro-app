import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:timer_app/feature/home/domain/entities/session_entity.dart';
import 'package:timer_app/feature/timer/domain/use_cases/clear_time_state_use_case.dart';
import 'package:timer_app/feature/timer/domain/use_cases/load_timer_state_use_case.dart';
import 'package:timer_app/feature/timer/domain/use_cases/save_timer_state_use_case.dart';
import 'package:timer_app/feature/timer/presentation/manager/timer_state.dart';

@injectable
class TimerCubit extends Cubit<TimerState> {
  final LoadTimerStateUseCase _loadTimerStateUseCase;
  final SaveTimerStateUseCase _saveTimerStateUseCase;
  final ClearTimeStateUseCase _clearTimeStateUseCase;
  Timer? _timer;

  TimerCubit(
    this._loadTimerStateUseCase,
    this._saveTimerStateUseCase,
    this._clearTimeStateUseCase,
  ) : super(const TimerState.initial());

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> initializeTimer(
    SessionEntity session, {
    bool autoStart = false,
  }) async {
    emit(const TimerState.loading());

    try {
      final savedState = await _loadTimerStateUseCase().then(
        (value) => value.fold((l) => null, (r) => r),
      );

      if (savedState != null && savedState.sessionId == session.id) {
        if (savedState.isExpired) {
          await _clearTimeStateUseCase().then(
            (value) => value.fold((l) => null, (r) => r),
          );

          emit(
            TimerState.loaded(
              session: session,
              remainingSeconds: session.duration * 60,
              isRunning: false,
              isPaused: false,
              isExpired: true,
            ),
          );
        } else {
          emit(
            TimerState.loaded(
              session: session,
              remainingSeconds: savedState.remainingSeconds,
              isRunning: savedState.isRunning,
              isPaused: savedState.isPaused,
              isRestored: true,
            ),
          );

          await Future.delayed(const Duration(milliseconds: 500));

          emit(
            TimerState.loaded(
              session: session,
              remainingSeconds: savedState.remainingSeconds,
              isRunning: false,
              isPaused: savedState.isPaused,
              isRestored: false,
            ),
          );

          if (savedState.isRunning && !savedState.isPaused) {
            startTimer();
          }
        }
      } else {
        emit(
          TimerState.loaded(
            session: session,
            remainingSeconds: session.duration * 60,
            isRunning: false,
            isPaused: false,
          ),
        );

        if (autoStart) {
          startTimer();
        }
      }
    } catch (e) {
      emit(TimerStateError(e.toString()));
    }
  }

  void startTimer() {
    if (state is! TimerStateLoaded) return;
    final currentState = state as TimerStateLoaded;

    if (currentState.isRunning || currentState.session == null) return;

    emit(currentState.copyWith(isRunning: true, isPaused: false));
    _saveTimerState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is! TimerStateLoaded) return;
      final currentState = state as TimerStateLoaded;

      if (currentState.remainingSeconds > 0) {
        final newRemainingSeconds = currentState.remainingSeconds - 1;
        emit(currentState.copyWith(remainingSeconds: newRemainingSeconds));
        _saveTimerState();
      } else {
        stopTimer();
        _clearTimeStateUseCase().then(
          (value) => value.fold((l) => null, (r) => r),
        );
      }
    });
  }

  void pauseTimer() {
    if (state is! TimerStateLoaded) return;
    final currentState = state as TimerStateLoaded;

    if (!currentState.isRunning) return;

    _timer?.cancel();
    emit(currentState.copyWith(isRunning: false, isPaused: true));
    _saveTimerState();
  }

  void resumeTimer() {
    if (state is! TimerStateLoaded) return;
    final currentState = state as TimerStateLoaded;

    if (!currentState.isPaused) return;

    emit(currentState.copyWith(isPaused: false));
    startTimer();
  }

  void stopTimer() {
    if (state is! TimerStateLoaded) return;
    final currentState = state as TimerStateLoaded;

    _timer?.cancel();
    emit(
      currentState.copyWith(
        isRunning: false,
        isPaused: false,
        isExpired: true,
        remainingSeconds: currentState.session?.duration != null
            ? currentState.session!.duration * 60
            : 0,
      ),
    );
    _saveTimerState();
  }

  void resetTimer() {
    if (state is! TimerStateLoaded) return;
    final currentState = state as TimerStateLoaded;

    _timer?.cancel();
    emit(
      currentState.copyWith(
        isRunning: false,
        isPaused: false,
        remainingSeconds: currentState.session?.duration != null
            ? currentState.session!.duration * 60
            : 0,
      ),
    );
    _saveTimerState();
  }

  Future<void> _saveTimerState() async {
    if (state is! TimerStateLoaded) return;
    final currentState = state as TimerStateLoaded;

    if (currentState.session != null) {
      await _saveTimerStateUseCase.call(
        session: currentState.session!,
        remainingSeconds: currentState.remainingSeconds,
        isRunning: currentState.isRunning,
        isPaused: currentState.isPaused,
      );
    }
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
