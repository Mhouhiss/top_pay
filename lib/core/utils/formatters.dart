import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final _currency =
  NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 2);

  static final _currencyNoDecimals =
  NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 0);

  static String currency(double amount, {bool decimals = true}) {
    return decimals ? _currency.format(amount) : _currencyNoDecimals.format(
        amount);
  }

  static String date(DateTime date) => DateFormat('MMM d, yyyy').format(date);

  static String time(DateTime date) => DateFormat('h:mm a').format(date);

  static String dateTime(DateTime date) =>
      DateFormat('MMM d, yyyy • h:mm a').format(date);

  static String relative(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return date_(date);
  }

  static String date_(DateTime date) => DateFormat('MMM d').format(date);

  /// Formats a phone number as the user types, e.g. 0801 234 5678.
  static String maskPhone(String phone) {
    if (phone.length < 4) return phone;
    final visible = phone.substring(0, phone.length - 4);
    return '${'*' * visible.length}${phone.substring(phone.length - 4)}';
  }
}