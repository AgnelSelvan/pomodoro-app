import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:timer_app/core/utils/error/failure.dart';
import 'package:timer_app/feature/home/domain/entities/session_entity.dart';
import 'package:timer_app/feature/timer/data/datasources/timer_local_data_source.dart';
import 'package:timer_app/feature/timer/data/models/timer_state_model.dart';
import 'package:timer_app/feature/timer/domain/entities/timer_state_entity.dart';
import 'package:timer_app/feature/timer/domain/repositories/timer_repository.dart';

@LazySingleton(as: TimerRepository)
class TimerRepositoryImpl implements TimerRepository {
  final TimerLocalDataSource _timerLocalDataSource;

  TimerRepositoryImpl({required TimerLocalDataSource timerLocalDataSource})
    : _timerLocalDataSource = timerLocalDataSource;

  @override
  Future<Either<Failure, void>> clearTimerState() async {
    try {
      await _timerLocalDataSource.clearTimerState();
      return Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> hasActiveTimer() async {
    try {
      return Right(await _timerLocalDataSource.hasActiveTimer());
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TimerStateEntity?>> loadTimerState() async {
    try {
      return Right((await _timerLocalDataSource.loadTimerState())?.toEntity());
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveTimerState({
    required SessionEntity session,
    required int remainingSeconds,
    required bool isRunning,
    required bool isPaused,
  }) async {
    try {
      await _timerLocalDataSource.saveTimerState(
        session: session,
        remainingSeconds: remainingSeconds,
        isRunning: isRunning,
        isPaused: isPaused,
      );
      return Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
