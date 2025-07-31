import 'dart:async';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class InactivityDetector {
  static const MethodChannel _channel = MethodChannel('inactivity_detector');

  Future<int> getInactivityDuration() async {
    final result = await _channel.invokeMethod('getInactivityDuration');
    return result as int;
  }
}
