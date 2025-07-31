import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:timer_app/core/utils/error/failure.dart';
import 'package:timer_app/feature/home/domain/entities/session_entity.dart';
import 'package:timer_app/feature/timer/domain/repositories/timer_repository.dart';

@lazySingleton
class SaveTimerStateUseCase {
  final TimerRepository _timerRepository;

  SaveTimerStateUseCase({required TimerRepository timerRepository})
    : _timerRepository = timerRepository;

  Future<Either<Failure, void>> call({
    required SessionEntity session,
    required int remainingSeconds,
    required bool isRunning,
    required bool isPaused,
  }) async {
    return _timerRepository.saveTimerState(
      session: session,
      remainingSeconds: remainingSeconds,
      isRunning: isRunning,
      isPaused: isPaused,
    );
  }
}
