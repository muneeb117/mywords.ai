import 'package:purchases_flutter/purchases_flutter.dart';

class StoreConfig {
  final Store store;
  final String apiKey;
  static StoreConfig? _instance;

  static void init({required Store store, required String apiKey}) {
    _instance ??= StoreConfig._internal(store: store, apiKey: apiKey);
  }

  StoreConfig._internal({required this.store, required this.apiKey});

  static StoreConfig get instance {
    return _instance!;
  }

  static bool isForAppleStore() =>
      instance.store == Store.appStore || instance.store == Store.macAppStore;

  static bool isForGooglePlay() => instance.store == Store.playStore;
}
