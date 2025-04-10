import 'package:mywords/config/flavors/env_config/base_config.dart';

class DevConfig implements BaseConfig {
  @override
  String get baseUrl => 'https://myword-pied.vercel.app';

  @override
  bool get isDebug => true;

  @override
  bool get reportErrors => false;

  @override
  bool get trackEvents => false;
}
