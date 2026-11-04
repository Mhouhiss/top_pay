import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String dayText(DateTime time) {
    if (time.hour < 12) return 'morning';
    if (time.hour < 16) return 'afternoon';
    return 'evening';
  }

  static String dateTime(DateTime date) {
    final day = date.day;
    final daySuffix = _daySuffix(day);
    final formattedDate = DateFormat('MMM, hh:mm a').format(date);
    return '$day$daySuffix $formattedDate';
  }

  static String _daySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  // For ordinary Transaction amount
  static String amount(double amount) {
    return NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    ).format(amount.abs());
  }

  // For transactions amount with sign in front
  static String transactionAmount(double amount, String type) {
    final formattedAmount = Formatters.amount(amount);
    final isCredit = type.toLowerCase() == 'funding';

    return isCredit ? '+$formattedAmount' : '−$formattedAmount';
  }

  static String date(DateTime date) => DateFormat('MMM d, yyyy').format(date);

  static String normalisePhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\s'), '');
    if (cleaned.startsWith('+234')) {
      return '0${cleaned.substring(4)}';
    }
    if (cleaned.startsWith('234')) {
      return '0${cleaned.substring(3)}';
    }
    return cleaned;
  }
}
