import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String dayText(DateTime time) {
    if (time.hour < 12) return 'morning';
    if (time.hour < 16) return 'afternoon';
    return 'evening';
  }

  static String dateTime(DateTime timestamp) {
    final hour = timestamp.hour % 12 == 0 ? 12 : timestamp.hour % 12;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';

    return '${timestamp.day}/${timestamp.month}/${timestamp.year} '
        '$hour:$minute $period';
  }

  static String amount(double amount) {
    final sign = amount >= 0 ? '+' : '-';
    final value = amount.abs().toStringAsFixed(2);
    return '$sign₦$value';
  }

  static String date(DateTime date) => DateFormat('MMM d, yyyy').format(date);

  static String date_(DateTime date) => DateFormat('MMM d').format(date);

  /// Formats a phone number as the user types, e.g. 0801 234 5678.
  static String maskPhone(String phone) {
    if (phone.length < 4) return phone;
    final visible = phone.substring(0, phone.length - 4);
    return '${'*' * visible.length}${phone.substring(phone.length - 4)}';
  }
}
