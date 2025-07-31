import 'package:dartz/dartz.dart';
import 'package:timer_app/core/utils/error/failure.dart';
import 'package:timer_app/feature/home/domain/entities/session_entity.dart';
import 'package:timer_app/feature/timer/domain/entities/timer_state_entity.dart';

abstract class TimerRepository {
  Future<Either<Failure, void>> saveTimerState({
    required SessionEntity session,
    required int remainingSeconds,
    required bool isRunning,
    required bool isPaused,
  });

  Future<Either<Failure, TimerStateEntity?>> loadTimerState();

  Future<Either<Failure, void>> clearTimerState();

  Future<Either<Failure, bool>> hasActiveTimer();
}
