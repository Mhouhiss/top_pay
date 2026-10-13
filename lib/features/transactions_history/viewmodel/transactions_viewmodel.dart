import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:top_pay/core/providers/api_provider.dart';
import 'package:top_pay/core/services/api_service.dart';
import 'package:top_pay/core/utils/api_error_handler.dart';
import 'package:top_pay/core/utils/logger.dart';
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
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class TransactionHistoryViewModel
    extends StateNotifier<TransactionHistoryState> {
  final ApiService _apiService;
  CancelToken? _cancelToken;

  TransactionHistoryViewModel(this._apiService)
    : super(const TransactionHistoryState());

  Future<void> loadTransactions({
    String? type,
    String? status,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (state.isLoading || state.isRefreshing) return;
    final cancelToken = CancelToken();
    _cancelToken = cancelToken;
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _fetchTransactions(
        cancelToken: cancelToken,
        type: type,
        status: status,
        search: search,
        startDate: startDate,
        endDate: endDate,
      );
      if (cancelToken.isCancelled || !mounted) return;
      final transactions = _parseTransactions(response);
      state = state.copyWith(transactions: transactions, isLoading: false);
      Logger.success('Loaded ${transactions.length} transactions.');
    } on ApiException catch (e) {
      Logger.error('Failed to load transactions: ${e.message}');
      if (mounted) {
        state = state.copyWith(isLoading: false, errorMessage: e.message);
      }
    }
  }

  Future<void> refreshTransactions({
    String? type,
    String? status,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (state.isRefreshing || state.isLoading) return;
    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    state = state.copyWith(isRefreshing: true, clearError: true);

    try {
      final response = await _fetchTransactions(
        cancelToken: cancelToken,
        type: type,
        status: status,
        search: search,
        startDate: startDate,
        endDate: endDate,
      );
      if (cancelToken.isCancelled || !mounted) return;
      final transactions = _parseTransactions(response);
      state = state.copyWith(
        transactions: transactions,
        isRefreshing: false,
        clearError: true,
      );
      Logger.success('Refreshed ${transactions.length} transactions.');
    } on ApiException catch (e) {
      Logger.error('Failed to refresh transactions: ${e.message}');
      if (mounted) {
        state = state.copyWith(isRefreshing: false, errorMessage: e.message);
      }
    }
  }

  List<TransactionModel> filterTransactions({
    String? type,
    String? status,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final query = search?.trim().toLowerCase() ?? '';

    return state.transactions.where((transaction) {
      final matchesType =
          type == null ||
          type.toLowerCase() == 'all' ||
          transaction.type.toLowerCase() == type.toLowerCase();

      final matchesStatus =
          status == null ||
          status.toLowerCase() == 'all' ||
          transaction.status.name.toLowerCase() == status.toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          transaction.description.toLowerCase().contains(query) ||
          transaction.reference.toLowerCase().contains(query) ||
          (transaction.phoneNumber?.toLowerCase().contains(query) ?? false);

      final matchesStartDate =
          startDate == null ||
          !transaction.createdAt.isBefore(
            DateTime(startDate.year, startDate.month, startDate.day),
          );

      final matchesEndDate =
          endDate == null ||
          transaction.createdAt.isBefore(
            DateTime(
              endDate.year,
              endDate.month,
              endDate.day,
            ).add(const Duration(days: 1)),
          );

      return matchesType &&
          matchesStatus &&
          matchesSearch &&
          matchesStartDate &&
          matchesEndDate;
    }).toList();
  }

  Future<Map<String, dynamic>> _fetchTransactions({
    required CancelToken cancelToken,
    String? type,
    String? status,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Real API Call
    // final response = await _apiService.get(
    //   ApiEndpoints.transactions,
    //   cancelToken: _cancelToken,
    //   queryParameters: {
    //     if (type != null && type.toLowerCase() != 'all') 'type': type,
    //     if (status != null && status.toLowerCase() != 'all') 'status': status,
    //     if (search != null && search.trim().isNotEmpty) 'search': search,
    //     if (startDate != null) 'startDate': startDate.toIso8601String(),
    //     if (endDate != null) 'endDate': endDate.toIso8601String(),
    //   },
    // );

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

  @override
  void dispose() {
    _cancelToken?.cancel('Transaction ViewModel disposed.');
    super.dispose();
  }
}

final transactionHistoryViewModelProvider =
    StateNotifierProvider<TransactionHistoryViewModel, TransactionHistoryState>(
      (ref) {
        return TransactionHistoryViewModel(ref.watch(apiServiceProvider));
      },
    );

final recentTransactionsProvider = Provider<List<TransactionModel>>((ref) {
  final transactions = ref.watch(
    transactionHistoryViewModelProvider.select((state) => state.transactions),
  );
  return transactions.take(5).toList();
});
