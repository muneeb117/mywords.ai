import 'package:bloc/bloc.dart';
import 'package:mywords/constants/app_keys.dart';
import 'package:mywords/core/iap/iap_service.dart';
import 'package:mywords/utils/extensions/either_extension.dart';
import 'package:purchases_flutter/models/entitlement_infos_wrapper.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';

part 'paywall_state.dart';

class PaywallCubit extends Cubit<PaywallState> {
  final IapService _iapService;

  PaywallCubit({required IapService iapService})
    : _iapService = iapService,
      super(PaywallState.initial()) {
    getOfferings();
  }

  Future<void> getEntitlement() async {
    final result = await _iapService.isPremiumUser();
    result.handle(
      onSuccess: (isPro) {
        emit(state.copyWith(isPremiumUser: isPro));
      },
      onError: (error) {
        emit(state.copyWith(isPremiumUser: false, errorMsg: error.errorMsg));
      },
    );
  }

  Future<void> markUserPremium(EntitlementInfos entitlements) async {
    final isPro = entitlements.all[AppKeys.entitlementKey]?.isActive ?? false;
    emit(state.copyWith(isPremiumUser: isPro));
  }

  Future<void> getOfferings() async {
    emit(state.copyWith(paywallStatus: PaywallStatus.loading));
    final result = await _iapService.getOffering();
    result.handle(
      onSuccess: (Offering offering) {
        emit(state.copyWith(paywallStatus: PaywallStatus.success, offering: offering));
      },
      onError: (error) {
        state.copyWith(
          paywallStatus: PaywallStatus.failure,
          errorMsg: error.errorMsg,
          isPremiumUser: false,
        );
      },
    );
  }
}
