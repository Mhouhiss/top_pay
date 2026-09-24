import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/core/router/router.dart';
import 'package:top_pay/core/theme/app_colors.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final borderRadius = BorderRadius.circular(AppSizes.radiusMd);

    return InkWell(
      onTap: () {
        context.push(AppRoutes.data);
      },
      borderRadius: borderRadius,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: borderRadius,
          border: Border.all(
            color: colorScheme.secondary.withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.local_offer_outlined, size: 20, color: AppColors.mtn),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Text(
                'MTN 1GB for ₦200 • Offer valid for 30 days',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.mtn,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
