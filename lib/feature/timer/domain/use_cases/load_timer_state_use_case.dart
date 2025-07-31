import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:timer_app/core/utils/error/failure.dart';
import 'package:timer_app/feature/timer/domain/entities/timer_state_entity.dart';
import 'package:timer_app/feature/timer/domain/repositories/timer_repository.dart';

@lazySingleton
class LoadTimerStateUseCase {
  final TimerRepository _timerRepository;

  LoadTimerStateUseCase({required TimerRepository timerRepository})
    : _timerRepository = timerRepository;

  Future<Either<Failure, TimerStateEntity?>> call() async {
    return _timerRepository.loadTimerState();
  }
}
