part of 'purchase_cubit.dart';

enum PurchaseStatus { initial, loading, success,cancelled, failure }


class PurchaseState {
  final PurchaseStatus status;
  final CustomerInfo? customerInfo;
  final String errorMessage;

  PurchaseState({
    required this.status,
    this.customerInfo,
    required this.errorMessage,
  });

  factory PurchaseState.initial() {
    return PurchaseState(status: PurchaseStatus.initial, errorMessage: '');
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
