import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:top_pay/core/theme/app_colors.dart';

class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double radius;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const CustomAvatar({
    super.key,
    this.imageUrl,
    required this.initials,
    this.radius = 22,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: (backgroundColor ?? AppColors.primary).withValues(
        alpha: 0.12,
      ),
      child: imageUrl == null || imageUrl!.isEmpty
          ? Text(
              initials,
              style: TextStyle(
                color: backgroundColor ?? AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: radius * 0.65,
              ),
            )
          : ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Text(
                  initials,
                  style: TextStyle(
                    color: backgroundColor ?? AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
    );

    if (onTap == null) return avatar;
    return GestureDetector(onTap: onTap, child: avatar);
  }
}

enum CustomBadgeVariant { success, error, warning, info, neutral }

/// Small pill-shaped status label (e.g. transaction status, KYC state).
class CustomBadge extends StatelessWidget {
  final String label;
  final CustomBadgeVariant variant;

  const CustomBadge({
    super.key,
    required this.label,
    this.variant = CustomBadgeVariant.neutral,
  });

  Color get _color {
    switch (variant) {
      case CustomBadgeVariant.success:
        return AppColors.success;
      case CustomBadgeVariant.error:
        return AppColors.error;
      case CustomBadgeVariant.warning:
        return AppColors.warning;
      case CustomBadgeVariant.info:
        return AppColors.info;
      case CustomBadgeVariant.neutral:
        return AppColors.textSecondaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _color,
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
