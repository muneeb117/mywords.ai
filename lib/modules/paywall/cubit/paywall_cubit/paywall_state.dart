part of 'paywall_cubit.dart';

enum PaywallStatus { initial, loading, success, failure, offline }

class PaywallState {
  final PaywallStatus paywallStatus;
  final Offering offering;
  final String errorMsg;
  final bool isPremiumUser;

  const PaywallState({
    required this.paywallStatus,
    required this.offering,
    required this.errorMsg,
    required this.isPremiumUser,
  });

  factory PaywallState.initial() {
    return const PaywallState(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaywallState &&
        other.paywallStatus == paywallStatus &&
        other.offering == offering &&
        other.errorMsg == errorMsg &&
        other.isPremiumUser == isPremiumUser;
  }

  @override
  int get hashCode {
    return paywallStatus.hashCode ^
        offering.hashCode ^
        errorMsg.hashCode ^
        isPremiumUser.hashCode;
  }
}
