import 'package:top_pay/features/bills/model/airtime_purchase_model.dart';

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

  static AirtimeNetwork? detectNetwork(String phone) {
    final number = normalisePhone(phone).replaceAll(RegExp(r'\D'), '');

    if (number.length < 4) return null;

    const prefixes = {
      AirtimeNetwork.mtn: [
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
      AirtimeNetwork.airtel: [
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
      AirtimeNetwork.glo: [
        '0705',
        '0805',
        '0807',
        '0811',
        '0815',
        '0905',
        '0915',
      ],
      AirtimeNetwork.nineMobile: [
        '0809',
        '0817',
        '0818',
        '0908',
        '0909',
      ],
    };

    for (final entry in prefixes.entries) {
      if (entry.value.any(number.startsWith)) {
        return entry.key;
      }
    }

    return null;
  }
}
