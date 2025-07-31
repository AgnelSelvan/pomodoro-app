import 'package:flutter/material.dart';
import 'package:timer_app/core/di/di.dart';
import 'package:timer_app/core/utils/routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pomodoro App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: getIt<AppRoutes>().router,
    );
  }
}
