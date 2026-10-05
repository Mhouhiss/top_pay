import 'dart:io';

import 'package:dio/dio.dart';
import 'package:top_pay/core/utils/logger.dart';

class ApiErrorHandler {
  ApiErrorHandler._();

  static const String _genericMessage =
      'Something went wrong. Please try again.';
  static const String _networkMessage =
      'No internet connection. Please check your network and try again.';
  static const String _timeoutMessage = 'Request timed out. Please try again.';
  static const String _serverMessage =
      'Something went wrong on our end. Please try again later.';

  static ApiException handle(DioException error) {
    final statusCode = error.response?.statusCode;

    Logger.debug(
      'Handling API error: type=${error.type}, statusCode=$statusCode',
      'API_ERROR',
    );

    //Network & Socket errors
    if (error.type == DioExceptionType.connectionError ||
        error.error is SocketException) {
      Logger.debug('API error identified as network error', 'API_ERROR');
      return const ApiException(message: _networkMessage);
    }

    //Timeout errors
    if (_isTimeout(error.type)) {
      Logger.debug('API error identified as timeout', 'API_ERROR');
      return const ApiException(message: _timeoutMessage);
    }

    //Request Cancellation
    if (error.type == DioExceptionType.cancel) {
      Logger.debug('API request was cancelled', 'API_ERROR');
      return const ApiException(message: 'Request was cancelled.');
    }

    // Server errors
    if (statusCode != null && statusCode >= 500) {
      Logger.debug('API error identified as server error', 'API_ERROR');

      return ApiException(message: _serverMessage, statusCode: statusCode);
    }

    //Client/API errors
    final serverData = error.response?.data;
    final extractedMessage = _extractServerMessage(serverData);
    final fallbackMessage = _getStatusMessage(statusCode);

    final finalMessage = extractedMessage ?? fallbackMessage;

    Logger.debug('API error mapped to message: "$finalMessage"', 'API_ERROR');

    return ApiException(
      message: finalMessage,
      statusCode: statusCode,
      data: serverData,
    );
  }

  static bool _isTimeout(DioExceptionType type) {
    return type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.transformTimeout;
  }

  static String? _extractServerMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      if (data['message'] != null && data['message'].toString().isNotEmpty) {
        return data['message'].toString();
      }
      if (data['error'] != null && data['error'].toString().isNotEmpty) {
        return data['error'].toString();
      }
      if (data['detail'] != null && data['detail'].toString().isNotEmpty) {
        return data['detail'].toString();
      }
    } else if (data is String && data.isNotEmpty) {
      return data;
    }

    return null;
  }

  static String _getStatusMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your information.';

      case 401:
        return 'Your session has expired. Please log in again.';

      case 403:
        return 'You don\'t have permission to perform this action.';

      case 404:
        return 'The requested resource was not found.';

      case 409:
        return 'This request conflicts with existing data.';

      case 422:
        return 'Some of the information provided is invalid.';

      case 429:
        return 'Too many requests. Please try again later.';

      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
        return _serverMessage;

      default:
        return _genericMessage;
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() => message;
}
