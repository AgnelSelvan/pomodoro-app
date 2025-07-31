import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:timer_app/core/utils/error/failure.dart';
import 'package:timer_app/feature/home/data/datasources/home_dataasource.dart';
import 'package:timer_app/feature/home/data/models/sessions_model.dart';
import 'package:timer_app/feature/home/domain/entities/sessions_entity.dart';
import 'package:timer_app/feature/home/domain/repositories/home_repository.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource _homeDataSource;

  HomeRepositoryImpl({required HomeDataSource homeDataSource})
    : _homeDataSource = homeDataSource;

  @override
  Future<Either<Failure, SessionsEntity>> getSessions() async {
    try {
      final sessions = await _homeDataSource.getSessions();
      return Right(sessions.toEntity());
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
