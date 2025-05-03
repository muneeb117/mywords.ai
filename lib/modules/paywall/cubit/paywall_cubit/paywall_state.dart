part of 'paywall_cubit.dart';

enum PaywallStatus { initial, loading, success, failure }

class PaywallState {
  final PaywallStatus paywallStatus;
  final Offering offering;
  final String errorMsg;
  final bool isPremiumUser;

  PaywallState({
    required this.paywallStatus,
    required this.offering,
    required this.errorMsg,
    required this.isPremiumUser,
  });

  factory PaywallState.initial() {
    return PaywallState(
      paywallStatus: PaywallStatus.initial,
      offering: Offering('', '', {}, []),
      errorMsg: '',
      isPremiumUser: false,
    );
  }

  PaywallState copyWith({
    PaywallStatus? paywallStatus,
    Offering? offering,
    String? errorMsg,
    bool? isPremiumUser,
  }) {
    return PaywallState(
      paywallStatus: paywallStatus ?? this.paywallStatus,
      offering: offering ?? this.offering,
      errorMsg: errorMsg ?? this.errorMsg,
      isPremiumUser: isPremiumUser ?? this.isPremiumUser,
    );
  }
}
