import 'package:mywords/config/flavors/base_config.dart';
import 'package:mywords/config/flavors/dev_config.dart';
import 'package:mywords/config/flavors/prod_config.dart';

enum AppEnv { dev, prod }

class Flavors {
  late BaseConfig _config;

  BaseConfig get config => _config;

  void initConfig(AppEnv appEnv) {
    _config = _getConfig(appEnv);
    print(" 'Environment' configured with $appEnv ✓");
  }

  BaseConfig _getConfig(AppEnv appEnv) {
    switch (appEnv) {
      case AppEnv.dev:
        return DevConfig();
      case AppEnv.prod:
        return ProdConfig();
      default:
        return DevConfig();
    }
  }
}
