import 'package:flutter/material.dart';
import 'package:top_pay/core/constants/app_assets.dart';

import '../../../../core/constants/app_sizes.dart';

class NetworkSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const NetworkSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const Map<String, String> _networkLogos = {
    'MTN': AppAssets.mtn,
    'Airtel': AppAssets.airtel,
    'Glo': AppAssets.glo,
    '9mobile': AppAssets.nineMobile,
  };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return PopupMenuButton<String>(
      initialValue: value,
      tooltip: 'Select network',
      onSelected: onChanged,
      itemBuilder: (context) {
        return _networkLogos.keys.map((network) {
          return PopupMenuItem<String>(
            value: network,
            child: Row(
              children: [
                _buildLogo(network),
                const SizedBox(width: AppSizes.sm),
                Text(network),
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

  Widget _buildLogo(String network) {
    final logo = _networkLogos[network];

    return ClipOval(
      child: SizedBox(
        height: 40,
        width: 40,
        child: logo != null
            ? Image.asset(
                logo,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _fallbackLogo(network),
              )
            : _fallbackLogo(network),
      ),
    );
  }

  Widget _fallbackLogo(String network) {
    return CircleAvatar(
      child: Text(
        network.substring(0, 1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
