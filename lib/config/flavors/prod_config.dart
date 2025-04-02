import 'package:mywords/config/flavors/base_config.dart';
import 'package:mywords/config/flavors/prod_config.dart';

class ProdConfig implements BaseConfig {
  @override
  String get baseUrl => 'https://api.com';

  @override
  bool get reportErrors => true;

  @override
  bool get trackEvents => true;
}
