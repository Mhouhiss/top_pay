class PhoneUtils {
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

  static String? detectNetwork(String phone) {
    final number = normalisePhone(phone).replaceAll(RegExp(r'\D'), '');

    if (number.length < 4) return null;

    const prefixes = {
      'MTN': [
        '07025',
        '07026',
        '0703',
        '0706',
        '0803',
        '0806',
        '0810',
        '0813',
        '0814',
        '0816',
        '0903',
        '0906',
        '0913',
        '0916',
      ],
      'Airtel': [
        '0701',
        '0708',
        '0802',
        '0808',
        '0812',
        '0901',
        '0902',
        '0907',
        '0912',
      ],
      'Glo': ['0705', '0805', '0807', '0811', '0815', '0905', '0915'],
      '9mobile': ['0809', '0817', '0818', '0908', '0909'],
    };

    for (final entry in prefixes.entries) {
      if (entry.value.any(number.startsWith)) {
        return entry.key;
      }
    }

    return null;
  }
}
