import 'package:dartz/dartz.dart';

/// Helps the read and understand the code better by handling the [success] case before the [error].
extension EitherExtensions<L, R> on Either<L, R> {
  void handle({required Function(R) onSuccess, required Function(L) onError}) {
    fold(onError, onSuccess);
  }
}
