import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:timer_app/core/utils/error/failure.dart';
import 'package:timer_app/feature/timer/domain/repositories/timer_repository.dart';

@lazySingleton
class HasActiveTimerUseCase {
  final TimerRepository _timerRepository;

  HasActiveTimerUseCase({required TimerRepository timerRepository})
    : _timerRepository = timerRepository;

  Future<Either<Failure, bool>> call() async {
    return _timerRepository.hasActiveTimer();
  }
}
