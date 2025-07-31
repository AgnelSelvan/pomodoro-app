import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer_app/core/di/di.dart';
import 'package:timer_app/feature/home/domain/entities/session_entity.dart';
import 'package:timer_app/feature/timer/domain/use_cases/clear_time_state_use_case.dart';
import 'package:timer_app/feature/timer/domain/use_cases/load_timer_state_use_case.dart';
import 'package:timer_app/feature/timer/domain/use_cases/save_timer_state_use_case.dart';

class SessionTimerWidget extends StatefulWidget {
  final SessionEntity session;
  final VoidCallback? onTimerComplete;
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
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _loadTimerState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadTimerState() async {
    final savedState = await getIt<LoadTimerStateUseCase>().call().then(
      (value) => value.fold((l) => null, (r) => r),
    );

    if (savedState != null && savedState.sessionId == widget.session.id) {
      if (savedState.isExpired) {
        await getIt<ClearTimeStateUseCase>().call().then(
          (value) => value.fold((l) => null, (r) => r),
        );
        setState(() {
          _remainingSeconds = widget.session.duration * 60;
          _isRunning = false;
          _isPaused = false;
        });
        widget.onTimerComplete?.call();
      } else {
        setState(() {
          _remainingSeconds = savedState.remainingSeconds;
          _isRunning = savedState.isRunning;
          _isPaused = savedState.isPaused;
        });

        if (_isRunning && !_isPaused) {
          _isRunning = false;
          setState(() {});
          _startTimer();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Timer restored: ${_formatTime(_remainingSeconds)} remaining',
            ),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      setState(() {
        _remainingSeconds = widget.session.duration * 60;
      });

      if (widget.isPlay) {
        _startTimer();
      }
    }
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    _saveTimerState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          _saveTimerState();
        } else {
          _stopTimer();
          widget.onTimerComplete?.call();
        }
      });

      if (_remainingSeconds <= 0) {
        getIt<ClearTimeStateUseCase>().call().then(
          (value) => value.fold((l) => null, (r) => r),
        );
      }
    });
  }

  Future<void> _saveTimerState() async {
    await getIt<SaveTimerStateUseCase>().call(
      session: widget.session,
      remainingSeconds: _remainingSeconds,
      isRunning: _isRunning,
      isPaused: _isPaused,
    );
  }

  void _pauseTimer() {
    if (!_isRunning) return;

    setState(() {
      _isPaused = true;
      _isRunning = false;
    });
    _timer?.cancel();
    _saveTimerState();
  }

  void _resumeTimer() {
    if (!_isPaused) return;

    setState(() {
      _isPaused = false;
    });
    _startTimer();
    _saveTimerState();
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _remainingSeconds = widget.session.duration * 60;
    });
    _saveTimerState();
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _remainingSeconds = widget.session.duration * 60;
    });
    _saveTimerState();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
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

  @override
  Widget build(BuildContext context) {
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
              _formatTime(_remainingSeconds),
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
                  if (!_isRunning && !_isPaused)
                    ElevatedButton.icon(
                      onPressed: _startTimer,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: sessionColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  if (_isRunning)
                    ElevatedButton.icon(
                      onPressed: _pauseTimer,
                      icon: const Icon(Icons.pause),
                      label: const Text('Pause'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  if (_isPaused)
                    ElevatedButton.icon(
                      onPressed: _resumeTimer,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Resume'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: sessionColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  if (_isRunning || _isPaused)
                    ElevatedButton.icon(
                      onPressed: _stopTimer,
                      icon: const Icon(Icons.stop),
                      label: const Text('Stop'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: _resetTimer,
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
}
