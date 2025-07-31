import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:timer_app/feature/home/domain/entities/sessions_entity.dart';
import 'package:timer_app/feature/home/domain/use_case/get_sessions_use_case.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetSessionsUseCase _getSessionsUseCase;

  HomeCubit(this._getSessionsUseCase) : super(HomeState.initial());

  Future<void> getSessions() async {
    emit(HomeState.loading());
    final result = await _getSessionsUseCase();
    result.fold(
      (failure) => emit(HomeState.failure(failure.message)),
      (sessions) => emit(HomeState.success(sessions)),
    );
  }
}
