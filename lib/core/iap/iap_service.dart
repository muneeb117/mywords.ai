import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class IapService {
  static const String _entitlementId = 'premium';

  /// Fetches the current available offering from RevenueCat
   Future<Offering?> getOffering() async {
    try {
      final offerings = await Purchases.getOfferings();
      final currentOffering = offerings.current;

      if (currentOffering == null || currentOffering.availablePackages.isEmpty) {
        debugPrint('[IAP] No current offering or packages available.');
        return null;
      }

      debugPrint('[IAP] Offering loaded: ${currentOffering.identifier}');
      return currentOffering;
    } catch (e, stackTrace) {
      debugPrint('[IAP] Error fetching offerings: $e');
      debugPrint('[IAP] Stacktrace:\n$stackTrace');
      return null;
    }
  }

  /// Checks if the user currently has access to the premium entitlement
   Future<bool> isPremiumUser() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final isActive = customerInfo.entitlements.all[_entitlementId]?.isActive ?? false;

      debugPrint('[IAP] Customer Info: $customerInfo');
      debugPrint('[IAP] Is Premium User: $isActive');

      return isActive;
    } catch (e, stackTrace) {
      debugPrint('[IAP] Error checking premium status: $e');
      debugPrint('[IAP] Stacktrace:\n$stackTrace');
      return false;
    }
  }
}
