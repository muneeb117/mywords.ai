import 'package:mywords/core/iap/store_config.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class IapConfig {
  static Future<void> init() async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration = PurchasesConfiguration(StoreConfig.instance.apiKey);

    configuration.entitlementVerificationMode = EntitlementVerificationMode.informational;
    configuration.pendingTransactionsForPrepaidPlansEnabled = true;
    await Purchases.configure(configuration);

    await Purchases.enableAdServicesAttributionTokenCollection();
  }
}
