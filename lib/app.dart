import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_app/core/di/di.dart';
import 'package:timer_app/core/utils/routes/app_routes.dart';
import 'package:timer_app/feature/home/presentation/manager/home_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()..getSessions(),
      child: MaterialApp.router(
        title: 'Pomodoro App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routerConfig: getIt<AppRoutes>().router,
      ),
    );
  }
}
