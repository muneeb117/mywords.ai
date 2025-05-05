import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mywords/core/iap/iap_service.dart';
import 'package:mywords/utils/extensions/either_extension.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final IapService _iapService;

  PurchaseCubit({required IapService iapService})
    : _iapService = iapService,
      super(PurchaseState.initial());

  Future<void> purchasePackage(Package package) async {
    emit(state.copyWith(status: PurchaseStatus.loading));

    final result = await _iapService.purchasePackage(package: package);

    result.handle(
      onSuccess: (customerInfo) {
        emit(state.copyWith(status: PurchaseStatus.success, customerInfo: customerInfo));
      },
      onError: (error) {
        log('catching in onError callback :: $error');
        if (error.code == 1) {
          emit(state.copyWith(status: PurchaseStatus.cancelled, errorMessage: error.errorMsg));
        } else {
          emit(state.copyWith(status: PurchaseStatus.failure, errorMessage: error.errorMsg));
        }
      },
    );
  }

}
