import 'package:bloc/bloc.dart';
import 'package:mywords/core/iap/iap_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final IapService _iapService;

  PurchaseCubit({required IapService iapService})
    : _iapService = iapService,
      super(PurchaseState.initial());

  void purchasePackage(Package package) async {
    CustomerInfo customerInfo = await Purchases.purchasePackage(package);
  }
}
