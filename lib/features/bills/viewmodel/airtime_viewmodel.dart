import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/airtime_purchase_model.dart';
import '../services/airtime_service.dart';

final airtimeServiceProvider = Provider<AirtimeService>((ref) {
  return AirtimeService();
});

final airtimeViewModelProvider =
    StateNotifierProvider<AirtimeViewModel, AirtimeState>((ref) {
      return AirtimeViewModel(ref.read(airtimeServiceProvider))
        ..loadWalletBalance();
    });

class AirtimeState {
  final bool isLoadingBalance;
  final double? walletBalance;
  final String? balanceError;
  final bool isPurchasing;
  final AirtimePurchaseRequest? request;
  final AirtimePurchaseResult? result;
  final String? purchaseError;

  const AirtimeState({
    this.isLoadingBalance = true,
    this.walletBalance,
    this.balanceError,
    this.isPurchasing = false,
    this.request,
    this.result,
    this.purchaseError,
  });

  AirtimeState copyWith({
    bool? isLoadingBalance,
    double? walletBalance,
    String? balanceError,
    bool? isPurchasing,
    AirtimePurchaseRequest? request,
    AirtimePurchaseResult? result,
    String? purchaseError,
    bool clearPurchaseError = false,
  }) {
    return AirtimeState(
      isLoadingBalance: isLoadingBalance ?? this.isLoadingBalance,
      walletBalance: walletBalance ?? this.walletBalance,
      balanceError: balanceError,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      request: request ?? this.request,
      result: result ?? this.result,
      purchaseError: clearPurchaseError
          ? null
          : (purchaseError ?? this.purchaseError),
    );
  }
}

class AirtimeViewModel extends StateNotifier<AirtimeState> {
  AirtimeViewModel(this._service) : super(const AirtimeState());

  final AirtimeService _service;

  Future<void> loadWalletBalance() async {
    state = state.copyWith(isLoadingBalance: true, balanceError: null);
    try {
      final balance = await _service.getWalletBalance();
      state = state.copyWith(
        isLoadingBalance: false,
        walletBalance: balance,
        balanceError: null,
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingBalance: false,
        balanceError: 'Unable to load wallet balance. Please try again.',
      );
    }
  }

  void setRequest(AirtimePurchaseRequest request) {
    state = state.copyWith(request: request, clearPurchaseError: true);
  }

  Future<void> purchase(String pin) async {
    final request = state.request;
    if (request == null) return;

    state = state.copyWith(isPurchasing: true, clearPurchaseError: true);
    try {
      final result = await _service.purchaseAirtime(
        request: request,
        transactionPin: pin,
      );
      state = state.copyWith(isPurchasing: false, result: result);
    } catch (_) {
      state = state.copyWith(
        isPurchasing: false,
        purchaseError: 'Transaction could not be completed. Please try again.',
      );
      rethrow;
    }
  }

  void clearTransaction() {
    state = AirtimeState(
      isLoadingBalance: false,
      walletBalance: state.walletBalance,
    );
  }
}
