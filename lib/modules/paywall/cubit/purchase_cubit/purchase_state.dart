part of 'purchase_cubit.dart';

enum PurchaseStatus { initial, loading, success, failure }

class PurchaseState {
  final PurchaseStatus purchaseStatus;
  final String errorMsg;

  PurchaseState({required this.purchaseStatus, required this.errorMsg});

  factory PurchaseState.initial() {
    return PurchaseState(purchaseStatus: PurchaseStatus.initial, errorMsg: '');
  }

  PurchaseState copyWith({PurchaseStatus? purchaseStatus, String? errorMsg}) {
    return PurchaseState(
      purchaseStatus: purchaseStatus ?? this.purchaseStatus,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
