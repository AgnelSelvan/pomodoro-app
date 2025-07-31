import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:timer_app/core/utils/error/failure.dart';
import 'package:timer_app/feature/home/domain/entities/sessions_entity.dart';
import 'package:timer_app/feature/home/domain/repositories/home_repository.dart';

@lazySingleton
class GetSessionsUseCase {
  final HomeRepository _homeRepository;
  GetSessionsUseCase({required HomeRepository homeRepository})
    : _homeRepository = homeRepository;

  Future<Either<Failure, SessionsEntity>> call() async {
    return await _homeRepository.getSessions();
  }
}
