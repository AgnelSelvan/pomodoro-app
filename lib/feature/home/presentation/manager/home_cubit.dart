import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:timer_app/feature/home/domain/entities/session_entity.dart';
import 'package:timer_app/feature/home/domain/entities/sessions_entity.dart';
import 'package:timer_app/feature/home/domain/use_case/get_sessions_use_case.dart';
import 'package:timer_app/feature/timer/domain/use_cases/clear_time_state_use_case.dart';
import 'package:timer_app/feature/timer/domain/use_cases/load_timer_state_use_case.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetSessionsUseCase _getSessionsUseCase;
  final LoadTimerStateUseCase _loadTimerStateUseCase;
  final ClearTimeStateUseCase _clearTimeStateUseCase;

  HomeCubit(
    this._getSessionsUseCase,
    this._loadTimerStateUseCase,
    this._clearTimeStateUseCase,
  ) : super(HomeState.initial());

  Future<void> getSessions() async {
    emit(HomeState.loading());
    final result = await _getSessionsUseCase();
    result.fold((failure) => emit(HomeState.failure(failure.message)), (
      sessions,
    ) async {
      final savedTimerState = await _loadTimerStateUseCase().then(
        (value) => value.fold((l) => null, (r) => r),
      );

      if (savedTimerState != null) {
        final currentSession = sessions.sessions.firstWhere(
          (session) => session.id == savedTimerState.sessionId,
          orElse: () => sessions.sessions[0],
        );

        emit(
          HomeState.success(
            sessions,
            currentSession,
            isPlay: savedTimerState.isRunning,
          ),
        );
      } else {
        emit(HomeState.success(sessions, sessions.sessions[0]));
      }
    });
  }

  Future<void> startSession(SessionEntity session) async {
    state.mapOrNull(
      success: (state) async {
        await _clearTimeStateUseCase().then(
          (value) => value.fold((l) => null, (r) => r),
        );
        emit(state.copyWith(currentSession: session, isPlay: true));
      },
    );
  }
}
