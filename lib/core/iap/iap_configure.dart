import 'package:mywords/core/iap/store_config.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class IapConfig {
  static Future<void> init() async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration = PurchasesConfiguration(StoreConfig.instance.apiKey);
    // Important: Enable StoreKit 2.0 for better StoreKit file compatibility

    configuration.entitlementVerificationMode = EntitlementVerificationMode.informational;
    configuration.pendingTransactionsForPrepaidPlansEnabled = true;
    await Purchases.configure(configuration);

    await Purchases.enableAdServicesAttributionTokenCollection();
  }
}
