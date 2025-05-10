import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mywords/constants/app_keys.dart';
import 'package:mywords/core/iap/iap_service.dart';
import 'package:mywords/utils/extensions/either_extension.dart';
import 'package:purchases_flutter/models/entitlement_infos_wrapper.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';

part 'paywall_state.dart';

class PaywallCubit extends HydratedCubit<PaywallState> {
  final IapService _iapService;

  PaywallCubit({required IapService iapService})
    : _iapService = iapService,
      super(PaywallState.initial()) {
    getOfferings();
  }

  Future<void> getEntitlement() async {
    emit(state.copyWith(isPremiumUser: true));
    return;
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

  Future<void> updateUserToPremium(EntitlementInfos entitlements) async {

    final isPro = entitlements.all[AppKeys.entitlementKey]?.isActive ?? false;
    print('IS PRO :: $isPro');
    emit(state.copyWith(isPremiumUser: isPro));
  }

  Future<void> getOfferings() async {
    // Only emit loading if we don't have cached data
    if (state.offering.identifier.isEmpty) {
      emit(state.copyWith(paywallStatus: PaywallStatus.loading));
    }

    final result = await _iapService.getOffering();
    result.handle(
      onSuccess: (Offering offering) {
        emit(
          state.copyWith(paywallStatus: PaywallStatus.success, offering: offering, errorMsg: ''),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            paywallStatus: PaywallStatus.failure,
            errorMsg: error.errorMsg,
            isPremiumUser: false,
          ),
        );
      },
    );
  }

  @override
  PaywallState? fromJson(Map<String, dynamic> json) {
    try {
      return PaywallState(
        paywallStatus: PaywallStatus.values[json['paywallStatus'] as int],
        offering: Offering.fromJson(json['offering'] as Map<String, dynamic>),
        errorMsg: json['errorMsg'] as String,
        isPremiumUser: json['isPremiumUser'] as bool,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(PaywallState state) {
    try {
      return {
        'paywallStatus': state.paywallStatus.index,
        'offering': state.offering.toJson(),
        'errorMsg': state.errorMsg,
        'isPremiumUser': state.isPremiumUser,
      };
    } catch (e) {
      return null;
    }
  }
}
