import 'package:flutter/material.dart';
import 'package:timer_app/app.dart';
import 'package:timer_app/core/di/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}
