import 'package:flutter/material.dart';
import 'package:top_pay/core/constants/app_assets.dart';
import 'package:top_pay/features/bills/model/airtime_purchase_model.dart';

import '../../../../core/constants/app_sizes.dart';

class NetworkSelector extends StatelessWidget {
  final AirtimeNetwork value;
  final ValueChanged<AirtimeNetwork> onChanged;

  const NetworkSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const Map<AirtimeNetwork, String> _networkLogos = {
    AirtimeNetwork.mtn: AppAssets.mtn,
    AirtimeNetwork.airtel: AppAssets.airtel,
    AirtimeNetwork.glo: AppAssets.glo,
    AirtimeNetwork.nineMobile: AppAssets.nineMobile,
  };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return PopupMenuButton<AirtimeNetwork>(
      initialValue: value,
      tooltip: 'Select network',
      onSelected: onChanged,
      itemBuilder: (context) {
        return AirtimeNetwork.values.map((network) {
          return PopupMenuItem<AirtimeNetwork>(
            value: network,
            child: Row(
              children: [
                _buildLogo(network),
                const SizedBox(width: AppSizes.sm),
                Text(network.label),
              ],
            ),
          );
        }).toList();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLogo(value),
          const SizedBox(width: AppSizes.xs),
          Icon(Icons.arrow_drop_down, color: colors.onSurfaceVariant),
        ],
      ),
    );
  }

  Widget _buildLogo(AirtimeNetwork network) {
    final logo = _networkLogos[network];

    return ClipOval(
      child: SizedBox(
        height: 40,
        width: 40,
        child: logo != null
            ? Image.asset(
                logo,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => _fallbackLogo(network),
              )
            : _fallbackLogo(network),
      ),
    );
  }

  Widget _fallbackLogo(AirtimeNetwork network) {
    return CircleAvatar(
      child: Text(
        network.label.substring(0, 1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
