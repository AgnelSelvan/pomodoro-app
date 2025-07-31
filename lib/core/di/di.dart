import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:timer_app/core/di/di.config.dart';

GetIt getIt = GetIt.instance;

@InjectableInit(
  preferRelativeImports: false,
  asExtension: false,
  throwOnMissingDependencies: true,
)
Future<void> configureDependencies({
  String? env,
  EnvironmentFilter? environmentFilter,
}) async {
  init(getIt, environmentFilter: environmentFilter, environment: env);
}
