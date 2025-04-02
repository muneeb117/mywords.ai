import 'package:mywords/config/flavors/env_config/base_config.dart';
import 'package:mywords/config/flavors/env_config/prod_config.dart';

class ProdConfig implements BaseConfig {
  @override
  String get baseUrl => 'https://api.com';

  @override
  bool get reportErrors => true;

  @override
  bool get trackEvents => true;
}
