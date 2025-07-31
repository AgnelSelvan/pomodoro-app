import 'package:flutter/material.dart';
import 'package:timer_app/app.dart';
import 'package:timer_app/core/di/di.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}
