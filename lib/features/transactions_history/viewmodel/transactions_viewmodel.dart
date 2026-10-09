import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:top_pay/core/providers/api_provider.dart';
import 'package:top_pay/core/services/api_service.dart';
import '../../transactions_history/model/transaction_model.dart';
import '../../transactions_history/viewmodel/dummy_transactions.dart';
// import 'package:top_pay/core/services/api_endpoints.dart';

class TransactionHistoryState {
  final List<TransactionModel> transactions;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;

  const TransactionHistoryState({
    this.transactions = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  TransactionHistoryState copyWith({
    List<TransactionModel>? transactions,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TransactionHistoryState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : errorMessage ?? errorMessage,
    );
  }
}

class TransactionHistoryViewModel
    extends StateNotifier<TransactionHistoryState> {
  final ApiService _apiService;

  TransactionHistoryViewModel(this._apiService)
      : super(const TransactionHistoryState());

  Future<void> loadTransactions() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _fetchTransactions();

      final transactions = _parseTransactions(response);

      state = state.copyWith(transactions: transactions, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> refreshTransactions() async {
    if (state.isRefreshing) return;

    state = state.copyWith(isRefreshing: true, clearError: true);

    try {
      final response = await _fetchTransactions();

      final transactions = _parseTransactions(response);

      state = state.copyWith(transactions: transactions, isRefreshing: false);
    } catch (e) {
      state = state.copyWith(isRefreshing: false, errorMessage: e.toString());
    }
  }

  Future<Map<String, dynamic>> _fetchTransactions({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Real API Call
    // final response = await _apiService.get(
    //   ApiEndpoints.transactions,
    //   queryParameters: {
    //     if (startDate != null) 'startDate': startDate.toIso8601String(),
    //     if (endDate != null) 'endDate': endDate.toIso8601String(),
    //   },
    // );
    //
    // return response.data as Map<String, dynamic>;

    // Dummy Data
    await Future.delayed(const Duration(milliseconds: 800));

    return DummyTransactions.response;
  }

  List<TransactionModel> _parseTransactions(Map<String, dynamic> response) {
    final data = response['transactions'] as List<dynamic>;

    return data
        .map((json) => TransactionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

final transactionHistoryViewModelProvider =
StateNotifierProvider<TransactionHistoryViewModel, TransactionHistoryState>(
      (ref) {
    final viewModel = TransactionHistoryViewModel(
        ref.watch(apiServiceProvider));
    viewModel.loadTransactions();
    return viewModel;
  },
);

final recentTransactionsProvider = Provider<List<TransactionModel>>((ref) {
  final transactions = ref.watch(
    transactionHistoryViewModelProvider.select((state) => state.transactions),
  );
  return transactions.take(5).toList();
});
