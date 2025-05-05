import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:mywords/constants/app_keys.dart';
import 'package:mywords/core/exceptions/purchase_error.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class IapService {

  Future<Either<PurchaseError, CustomerInfo>> purchasePackage({
    required Package package,
    String context = 'Package Purchase',
  }) async {
    try {
      final customerInfo = await Purchases.purchasePackage(package);
      log('Purchase successful for package: ${package.identifier}');
      return Right(customerInfo);
    } on PlatformException catch (e, stackTrace) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      log('Purchase failed with PlatformException: ${e.message}', error: e, stackTrace: stackTrace);

      print('error code is :: $errorCode');
      switch (errorCode) {
        case PurchasesErrorCode.networkError:
          return Left(
            PurchaseError(
              code: errorCode.index,
              errorMsg: 'Network connection issue. Please check your internet and try again.',
              exception: e,
            ),
          );
        case PurchasesErrorCode.offlineConnectionError:
          return Left(
            PurchaseError(
              code: errorCode.index,
              errorMsg: 'Network connection issue. Please check your internet and try again.',
              exception: e,
            ),
          );
        case PurchasesErrorCode.purchaseCancelledError:
          return Left(
            PurchaseError(code: errorCode.index, errorMsg: 'Purchase was cancelled.', exception: e),
          );
        case PurchasesErrorCode.paymentPendingError:
          return Left(
            PurchaseError(
              code: errorCode.index,
              errorMsg: 'Payment is pending approval.',
              exception: e,
            ),
          );
        case PurchasesErrorCode.receiptAlreadyInUseError:
          return Left(
            PurchaseError(
              code: errorCode.index,
              errorMsg: 'This purchase has already been applied to your account.',
              exception: e,
            ),
          );
        default:
          return Left(
            PurchaseError(
              code: errorCode.index,
              errorMsg: 'Payment failed: ${e.message ?? "Unknown error"}',
              exception: e,
            ),
          );
      }
    } catch (e, stackTrace) {
      log('Unexpected error during purchase', error: e, stackTrace: stackTrace);
      return Left(
        PurchaseError(
          code: -1,
          errorMsg: 'An unexpected error occurred. Please try again later.',
          exception: e,
        ),
      );
    }
  }

  Future<Either<PurchaseError, Offering>> getOffering() async {
    try {
      final offerings = await Purchases.getOfferings();
      final currentOffering = offerings.current;

      if (currentOffering == null) {
        log('[IAP] No current offering available');
        return Left(
          PurchaseError(code: -100, errorMsg: 'No subscription offerings available at this time'),
        );
      }

      if (currentOffering.availablePackages.isEmpty) {
        log('[IAP] Current offering has no packages: ${currentOffering.identifier}');
        return Left(
          PurchaseError(code: -101, errorMsg: 'No subscription packages available for purchase'),
        );
      }

      log(
        '[IAP] Offering loaded successfully: ${currentOffering.identifier} with ${currentOffering.availablePackages.length} packages',
      );
      return Right(currentOffering);
    } on PlatformException catch (e, stackTrace) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      log('[IAP] Platform exception fetching offerings', error: e, stackTrace: stackTrace);

      return Left(
        PurchaseError(
          code: errorCode.index,
          errorMsg: 'Failed to load subscription offerings: ${e.message ?? "Unknown error"}',
          exception: e,
        ),
      );
    } catch (e, stackTrace) {
      log('[IAP] Unexpected error fetching offerings', error: e, stackTrace: stackTrace);
      return Left(
        PurchaseError(
          code: -1,
          errorMsg: 'Failed to load subscription data. Please check your connection and try again.',
          exception: e,
        ),
      );
    }
  }

  Future<Either<PurchaseError, bool>> isPremiumUser() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final isActive = customerInfo.entitlements.all[AppKeys.entitlementKey]?.isActive ?? false;

      log('[IAP] Customer Info retrieved successfully');
      log('[IAP] Is Premium User: $isActive');

      return Right(isActive);
    } on PlatformException catch (e, stackTrace) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      log('[IAP] Platform exception checking premium status', error: e, stackTrace: stackTrace);

      return Left(
        PurchaseError(
          code: errorCode.index,
          errorMsg: 'Failed to verify subscription status',
          exception: e,
        ),
      );
    } catch (e, stackTrace) {
      log('[IAP] Error checking premium status', error: e, stackTrace: stackTrace);
      return Left(
        PurchaseError(code: -1, errorMsg: 'Unable to verify subscription status', exception: e),
      );
    }
  }

  Future<Either<PurchaseError, void>> login(String userID) async {
    try {
      await Purchases.logIn(userID);
      log('[IAP] User logged in successfully: $userID');
      return const Right(null);
    } on PlatformException catch (e, stackTrace) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      log('[IAP] Platform exception during login', error: e, stackTrace: stackTrace);

      return Left(
        PurchaseError(
          code: errorCode.index,
          errorMsg: 'Failed to sync subscription account',
          exception: e,
        ),
      );
    } catch (e, stackTrace) {
      log('[IAP] Error during login', error: e, stackTrace: stackTrace);
      return Left(
        PurchaseError(code: -1, errorMsg: 'Failed to sync subscription account', exception: e),
      );
    }
  }

  Future<Either<PurchaseError, void>> logout() async {
    try {
      await Purchases.logOut();
      log('[IAP] User logged out successfully');
      return const Right(null);
    } on PlatformException catch (e, stackTrace) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      log('[IAP] Platform exception during logout', error: e, stackTrace: stackTrace);

      return Left(
        PurchaseError(
          code: errorCode.index,
          errorMsg: 'Failed to sign out of subscription account',
          exception: e,
        ),
      );
    } catch (e, stackTrace) {
      log('[IAP] Error during logout', error: e, stackTrace: stackTrace);
      return Left(
        PurchaseError(
          code: -1,
          errorMsg: 'Failed to sign out of subscription account',
          exception: e,
        ),
      );
    }
  }
}
