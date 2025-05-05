// Custom error class to match pattern from example
class PurchaseError {
  final int code;
  final String errorMsg;
  final dynamic exception;

  PurchaseError({
    required this.code,
    required this.errorMsg,
    this.exception,
  });

  @override
  String toString() => 'PurchaseError($code): $errorMsg';
}