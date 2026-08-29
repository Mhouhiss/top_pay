import 'package:flutter/foundation.dart';

class Logger {
  static const String _defaultTag = 'TopApp';

  static void debug(String message, [String? tag]) {
    if (!kDebugMode) return;

    _log('💻', message, tag);
  }

  static void info(String message, [String? tag]) {
    if (!kDebugMode) return;

    _log('ℹ️', message, tag);
  }

  static void warning(String message, [String? tag]) {
    if (!kDebugMode) return;

    _log('⚠️', message, tag);
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (!kDebugMode) return;

    _log('❌', message, tag);

    if (error != null) {
      debugPrint('   Error: $error');
    }

    if (stackTrace != null) {
      debugPrint('   StackTrace:\n$stackTrace');
    }
  }

  static void success(String message, [String? tag]) {
    if (!kDebugMode) return;

    _log('✅', message, tag);
  }

  static void network(
    String method,
    String url, {
    int? statusCode,
    String? tag,
  }) {
    if (!kDebugMode) return;

    final status = statusCode != null ? ' [$statusCode]' : '';

    _log('🌐', '$method $url$status', tag);
  }

  static void userAction(
    String action, {
    Map<String, dynamic>? data,
    String? tag,
  }) {
    if (!kDebugMode) return;

    final details = data != null ? ' | Data: $data' : '';

    _log('👤', 'User Action: $action$details', tag);
  }

  static void _log(String icon, String message, String? tag) {
    debugPrint('$icon [${tag ?? _defaultTag}] $message');
  }
}
