import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:mywords/core/iap/iap_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final IapService _iapService;

  PurchaseCubit({required IapService iapService})
    : _iapService = iapService,
      super(PurchaseState.initial());

  Future<void> purchasePackage(Package package) async {
    try {
      emit(state.copyWith(status: PurchaseStatus.loading));

      final customerInfo = await Purchases.purchasePackage(package);
      print('customer info :: $customerInfo');

      emit(
        state.copyWith(
          status: PurchaseStatus.success,
          customerInfo: customerInfo,
          errorMessage: null,
        ),
      );
    } on PlatformException catch (e) {
      print('error $e');

      final error = PurchasesErrorHelper.getErrorCode(e);
      emit(state.copyWith(status: PurchaseStatus.failure, errorMessage: 'Purchase failed: $error'));
    } catch (e) {
      print('error $e');
      emit(
        state.copyWith(
          status: PurchaseStatus.failure,
          errorMessage: 'An unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }
}
