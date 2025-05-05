part of 'purchase_cubit.dart';

enum PurchaseStatus { initial, loading, success,cancelled, failure }


class PurchaseState {
  final PurchaseStatus status;
  final CustomerInfo? customerInfo;
  final String errorMessage;
  final String? lastPurchaseDate;
  final String? lastPackageId;

  PurchaseState({
    required this.status,
    this.customerInfo,
    required this.errorMessage,
    this.lastPurchaseDate,
    this.lastPackageId,
  });

  factory PurchaseState.initial() {
    return PurchaseState(
      status: PurchaseStatus.initial, 
      errorMessage: '',
      lastPurchaseDate: null,
      lastPackageId: null,
    );
  }

  PurchaseState copyWith({
    PurchaseStatus? status,
    CustomerInfo? customerInfo,
    String? errorMessage,
    String? lastPurchaseDate,
    String? lastPackageId,
  }) {
    return PurchaseState(
      status: status ?? this.status,
      customerInfo: customerInfo ?? this.customerInfo,
      errorMessage: errorMessage ?? this.errorMessage,
      lastPurchaseDate: lastPurchaseDate ?? this.lastPurchaseDate,
      lastPackageId: lastPackageId ?? this.lastPackageId,
    );
  }
}
