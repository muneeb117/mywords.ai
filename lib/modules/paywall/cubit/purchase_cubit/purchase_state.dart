part of 'purchase_cubit.dart';

enum PurchaseStatus { initial, loading, success, failure }


class PurchaseState {
  final PurchaseStatus status;
  final CustomerInfo? customerInfo;
  final String? errorMessage;

  PurchaseState({
    required this.status,
    this.customerInfo,
    this.errorMessage,
  });

  factory PurchaseState.initial() {
    return PurchaseState(status: PurchaseStatus.initial);
  }

  PurchaseState copyWith({
    PurchaseStatus? status,
    CustomerInfo? customerInfo,
    String? errorMessage,
  }) {
    return PurchaseState(
      status: status ?? this.status,
      customerInfo: customerInfo ?? this.customerInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
