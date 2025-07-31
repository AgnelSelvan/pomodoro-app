import 'package:dartz/dartz.dart';
import 'package:timer_app/core/utils/error/failure.dart';
import 'package:timer_app/feature/home/domain/entities/sessions_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, SessionsEntity>> getSessions();
}
