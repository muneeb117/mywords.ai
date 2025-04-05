import 'package:mywords/config/flavors/env_config/base_config.dart';
import 'package:mywords/config/flavors/env_config/prod_config.dart';

class ProdConfig implements BaseConfig {
  @override
  String get baseUrl => 'https://myword-pied.vercel.app';

  @override
  bool get isDebug => false;

  @override
  bool get reportErrors => true;

  @override
  bool get trackEvents => true;
}
