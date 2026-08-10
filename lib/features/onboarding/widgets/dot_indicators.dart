import 'package:flutter/material.dart';
import 'package:top_pay/core/constants/app_constants.dart';
import 'package:top_pay/core/constants/app_sizes.dart';

class DotIndicators extends StatelessWidget {
  final int count;
  final int currentIndex;

  const DotIndicators({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final bool isActive = index == currentIndex;
        return AnimatedContainer(
          duration: AppConstants.mediumAnimation,
          margin: const EdgeInsets.symmetric(horizontal: AppSizes.xs),
          height: AppSizes.sm,
          width: isActive ? AppSizes.lg : AppSizes.sm,
          decoration: BoxDecoration(
            color: isActive
                ? colorScheme.primary
                : colorScheme.primary.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppSizes.radiusPill),
          ),
        );
      }),
    );
  }
}
