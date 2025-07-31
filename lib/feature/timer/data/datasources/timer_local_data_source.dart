import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_app/feature/home/domain/entities/session_entity.dart';
import 'package:timer_app/feature/timer/data/models/timer_state_model.dart';

abstract class TimerLocalDataSource {
  Future<void> saveTimerState({
    required SessionEntity session,
    required int remainingSeconds,
    required bool isRunning,
    required bool isPaused,
  });

  Future<TimerStateModel?> loadTimerState();

  Future<void> clearTimerState();

  Future<bool> hasActiveTimer();
}

@LazySingleton(as: TimerLocalDataSource)
class TimerLocalDataSourceImpl implements TimerLocalDataSource {
  final SharedPreferences _prefs;
  TimerLocalDataSourceImpl({required SharedPreferences appSharedPrefs})
    : _prefs = appSharedPrefs;
  @override
  Future<void> saveTimerState({
    required SessionEntity session,
    required int remainingSeconds,
    required bool isRunning,
    required bool isPaused,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    final timerStateModel = TimerStateModel(
      isPaused: isPaused,
      isRunning: isRunning,
      remainingSeconds: remainingSeconds,
      sessionId: session.id,
      startTime: now,
    );

    final json = jsonEncode(timerStateModel.toJson());

    await _prefs.setString(_sessionIdKey, json);
  }

  @override
  Future<TimerStateModel?> loadTimerState() async {
    final json = _prefs.getString(_sessionIdKey);
    if (json == null) {
      return null;
    }
    final timerStateModel = TimerStateModel.fromJson(jsonDecode(json));

    final now = DateTime.now().millisecondsSinceEpoch;
    final elapsedSeconds = (now - timerStateModel.startTime) ~/ 1000;

    int remainingSeconds = timerStateModel.remainingSeconds;

    if (timerStateModel.isRunning && !timerStateModel.isPaused) {
      remainingSeconds = (remainingSeconds - elapsedSeconds).clamp(
        0,
        remainingSeconds,
      );
    }

    return timerStateModel.copyWith(remainingSeconds: remainingSeconds);
  }

  @override
  Future<void> clearTimerState() async {
    await _prefs.remove(_sessionIdKey);
  }

  @override
  Future<bool> hasActiveTimer() async {
    final state = await loadTimerState();
    return state != null && state.isRunning && state.remainingSeconds > 0;
  }

  static const String _sessionIdKey = 'session_id';
}
