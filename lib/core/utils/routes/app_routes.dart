import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:timer_app/feature/home/presentation/pages/home_page.dart';

@lazySingleton
class AppRoutes {
  final home = '/';

  GoRouter get router => GoRouter(
    routes: [
      GoRoute(path: home, builder: (context, state) => const HomePage()),
    ],
  );
}
