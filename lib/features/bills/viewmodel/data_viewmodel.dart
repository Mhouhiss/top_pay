import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bills/model/airtime_purchase_model.dart';
import '../model/data_bundle_model.dart';
import '../services/data_service.dart';

final dataServiceProvider = Provider<DataService>((ref) => DataService());

final dataViewModelProvider = StateNotifierProvider<DataViewModel, DataState>((
  ref,
) {
  return DataViewModel(ref.read(dataServiceProvider))..loadWalletBalance();
});

class DataState {
  final bool isLoadingBalance;
  final double? walletBalance;
  final String? balanceError;
  final bool isLoadingBundles;
  final List<DataBundleModel> bundles;
  final String? bundlesError;
  final bool isPurchasing;
  final DataPurchaseRequest? request;
  final DataPurchaseResult? result;
  final String? purchaseError;

  const DataState({
    this.isLoadingBalance = true,
    this.walletBalance,
    this.balanceError,
    this.isLoadingBundles = false,
    this.bundles = const [],
    this.bundlesError,
    this.isPurchasing = false,
    this.request,
    this.result,
    this.purchaseError,
  });

  DataState copyWith({
    bool? isLoadingBalance,
    double? walletBalance,
    String? balanceError,
    bool? isLoadingBundles,
    List<DataBundleModel>? bundles,
    String? bundlesError,
    bool? isPurchasing,
    DataPurchaseRequest? request,
    DataPurchaseResult? result,
    String? purchaseError,
    bool clearPurchaseError = false,
  }) {
    return DataState(
      isLoadingBalance: isLoadingBalance ?? this.isLoadingBalance,
      walletBalance: walletBalance ?? this.walletBalance,
      balanceError: balanceError,
      isLoadingBundles: isLoadingBundles ?? this.isLoadingBundles,
      bundles: bundles ?? this.bundles,
      bundlesError: bundlesError,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      request: request ?? this.request,
      result: result ?? this.result,
      purchaseError: clearPurchaseError
          ? null
          : (purchaseError ?? this.purchaseError),
    );
  }
}

class DataViewModel extends StateNotifier<DataState> {
  DataViewModel(this._service) : super(const DataState());

  final DataService _service;

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

  Future<void> loadBundles(AirtimeNetwork network) async {
    state = state.copyWith(
      isLoadingBundles: true,
      bundlesError: null,
      bundles: const [],
    );
    try {
      final bundles = await _service.getBundles(network);
      state = state.copyWith(
        isLoadingBundles: false,
        bundles: bundles,
        bundlesError: null,
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingBundles: false,
        bundlesError: 'Unable to load data bundles. Please try again.',
      );
    }
  }

  void setRequest(DataPurchaseRequest request) {
    state = state.copyWith(request: request, clearPurchaseError: true);
  }

  Future<DataPurchaseResult> purchase(String pin) async {
    final request = state.request;
    if (request == null) {
      throw StateError('No data purchase is ready to submit.');
    }

    state = state.copyWith(isPurchasing: true, clearPurchaseError: true);
    try {
      final result = await _service.purchaseData(
        request: request,
        transactionPin: pin,
      );
      state = state.copyWith(isPurchasing: false, result: result);
      return result;
    } catch (_) {
      state = state.copyWith(
        isPurchasing: false,
        purchaseError: 'Transaction could not be completed. Please try again.',
      );
      rethrow;
    }
  }

  void clearTransaction() {
    state = DataState(
      isLoadingBalance: false,
      walletBalance: state.walletBalance,
      bundles: state.bundles,
    );
  }
}
