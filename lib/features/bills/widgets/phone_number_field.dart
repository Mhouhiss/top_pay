import 'package:flutter/material.dart';
import 'package:top_pay/features/bills/model/airtime_purchase_model.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/phone_utils.dart';
import 'contact_picker_button.dart';
import 'network_selector.dart';

class PhoneNumberField extends StatelessWidget {
  final String network;
  final ValueChanged<String> onNetworkChanged;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PhoneNumberField({
    super.key,
    required this.network,
    required this.onNetworkChanged,
    required this.controller,
    required this.validator,
  });

  void _handlePhoneChanged(String value) {
    final detectedNetwork = PhoneUtils.detectNetwork(value);

    if (detectedNetwork != null && detectedNetwork != network) {
      onNetworkChanged(detectedNetwork);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Row(
        children: [
          NetworkSelector(value: network, onChanged: onNetworkChanged),

          Container(
            height: 32,
            width: 1,
            color: colors.outlineVariant,
            margin: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
          ),

          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              onChanged: _handlePhoneChanged,
              validator: validator,
              decoration: const InputDecoration(
                hintText: 'Enter number',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),

          ContactPickerButton(
            normalisePhone: PhoneUtils.normalisePhone,
            onPhoneSelected: (phone) {
              controller.text = phone;
              _handlePhoneChanged(phone);
            },
          ),
        ],
      ),
    );
  }
}
