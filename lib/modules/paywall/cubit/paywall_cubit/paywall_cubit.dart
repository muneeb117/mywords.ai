import 'package:bloc/bloc.dart';
import 'package:mywords/core/iap/iap_service.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';

part 'paywall_state.dart';

class PaywallCubit extends Cubit<PaywallState> {
  final IapService _iapService;

  PaywallCubit({required IapService iapService})
      : _iapService = iapService,
        super(PaywallState.initial());

  Future<void> getEntitlement() async {
    try {
      final isPro = await _iapService.isPremiumUser();
      emit(state.copyWith(isPremiumUser: isPro));
    } catch (e) {
      emit(state.copyWith(isPremiumUser: false, errorMsg: 'Failed to verify entitlement: $e'));
    }
  }

  Future<void> getOfferings() async {
    emit(state.copyWith(paywallStatus: PaywallStatus.loading));

    try {
      final offering = await _iapService.getOffering();

      if (offering == null) {
        emit(state.copyWith(paywallStatus: PaywallStatus.failure, errorMsg: 'No offerings found.'));
        return;
      }

      emit(state.copyWith(paywallStatus: PaywallStatus.success, offering: offering));
    } catch (e) {
      emit(
        state.copyWith(
          paywallStatus: PaywallStatus.failure,
          errorMsg: 'Something went wrong: $e',
          isPremiumUser: false,
        ),
      );
    }
  }
}
