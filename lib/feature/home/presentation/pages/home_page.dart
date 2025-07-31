import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_app/core/di/di.dart';
import 'package:timer_app/feature/home/domain/entities/session_entity.dart';
import 'package:timer_app/feature/home/domain/entities/sessions_entity.dart';
import 'package:timer_app/feature/home/presentation/manager/home_cubit.dart';
import 'package:timer_app/feature/timer/presentation/manager/timer_cubit.dart';
import 'package:timer_app/feature/timer/presentation/widgets/session_timer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UniqueKey key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        backgroundColor: Colors.purple.shade200,
        elevation: 0,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            success: (sessions, currentSession, isPlay) =>
                _buildSessionsTimer(sessions, currentSession, isPlay),
            failure: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading sessions',
                    style: TextStyle(fontSize: 18, color: Colors.red[400]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeCubit>().getSessions();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSessionsTimer(
    SessionsEntity sessions,
    SessionEntity currentSession,
    bool isPlay,
  ) {
    if (sessions.sessions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No sessions available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      key: key,
      child: BlocProvider(
        create: (context) => getIt<TimerCubit>(),
        child: SessionTimerWidget(
          session: currentSession,
          onTimerComplete: (ctx) {
            final nextIndex =
                (sessions.sessions.indexOf(currentSession) + 1) %
                sessions.sessions.length;
            final nextSession = sessions.sessions[nextIndex];

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${currentSession.name} completed! Starting ${nextSession.name}',
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
            key = UniqueKey();
            setState(() {});

            context.read<HomeCubit>().startSession(nextSession);
          },
          isPlay: isPlay,
        ),
      ),
    );
  }
}
