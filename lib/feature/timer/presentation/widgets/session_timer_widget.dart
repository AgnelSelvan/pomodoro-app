import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_app/feature/home/domain/entities/session_entity.dart';
import 'package:timer_app/feature/timer/presentation/manager/timer_cubit.dart';
import 'package:timer_app/feature/timer/presentation/manager/timer_state.dart';

class SessionTimerWidget extends StatefulWidget {
  final SessionEntity session;
  final Function(BuildContext)? onTimerComplete;
  final bool isPlay;

  const SessionTimerWidget({
    super.key,
    required this.session,
    required this.isPlay,
    this.onTimerComplete,
  });

  @override
  State<SessionTimerWidget> createState() => _SessionTimerWidgetState();
}

class _SessionTimerWidgetState extends State<SessionTimerWidget> {
  @override
  void initState() {
    super.initState();
    context.read<TimerCubit>().initializeTimer(
      widget.session,
      autoStart: widget.isPlay,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimerCubit, TimerState>(
      listener: (context, state) {
        if (state is TimerStateLoaded) {
          if (state.isRestored) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Timer restored: ${context.read<TimerCubit>().formatTime(state.remainingSeconds)} remaining',
                ),
                backgroundColor: Colors.blue,
                duration: const Duration(seconds: 2),
              ),
            );
          }

          if (state.isExpired) {
            widget.onTimerComplete?.call(context);
          }
        }
      },
      builder: (context, state) {
        if (state is TimerStateInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TimerStateLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TimerStateError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                const SizedBox(height: 16),
                Text(
                  'Error loading timer',
                  style: TextStyle(fontSize: 18, color: Colors.red[400]),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (state is TimerStateLoaded) {
          return _buildTimerUI(state);
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildTimerUI(TimerStateLoaded state) {
    final sessionColor = _getSessionColor();

    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              sessionColor.withOpacity(0.1),
              sessionColor.withOpacity(0.2),
            ],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  _getIconData(widget.session.icon),
                  size: 32,
                  color: sessionColor,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.session.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.session.description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              context.read<TimerCubit>().formatTime(state.remainingSeconds),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: sessionColor,
              ),
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                spacing: 10,
                children: [
                  if (!state.isRunning && !state.isPaused)
                    ElevatedButton.icon(
                      onPressed: () => context.read<TimerCubit>().startTimer(),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: sessionColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  if (state.isRunning)
                    ElevatedButton.icon(
                      onPressed: () => context.read<TimerCubit>().pauseTimer(),
                      icon: const Icon(Icons.pause),
                      label: const Text('Pause'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  if (state.isPaused)
                    ElevatedButton.icon(
                      onPressed: () => context.read<TimerCubit>().resumeTimer(),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Resume'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: sessionColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  if (state.isRunning || state.isPaused)
                    ElevatedButton.icon(
                      onPressed: () => context.read<TimerCubit>().stopTimer(),
                      icon: const Icon(Icons.stop),
                      label: const Text('Stop'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: () => context.read<TimerCubit>().resetTimer(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSessionColor() {
    try {
      String hexColor = widget.session.color;
      if (hexColor.startsWith('#')) {
        hexColor = hexColor.substring(1);
      }
      return Color(int.parse('FF$hexColor', radix: 16));
    } catch (e) {
      return Colors.blue;
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'work':
        return Icons.work;
      case 'coffee':
        return Icons.coffee;
      case 'restaurant':
        return Icons.restaurant;
      case 'timer':
        return Icons.timer;
      case 'play':
        return Icons.play_arrow;
      case 'pause':
        return Icons.pause;
      case 'stop':
        return Icons.stop;
      default:
        return Icons.timer;
    }
  }
}
