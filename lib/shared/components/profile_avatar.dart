import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:top_pay/core/constants/app_assets.dart';
import 'package:top_pay/core/theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.photoUrl,
    this.radius = 20.0,
    this.backgroundColor = AppColors.black,
  });

  final String? photoUrl;
  final double radius;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasUrl = photoUrl?.trim().isNotEmpty == true;

    return CircleAvatar(
      radius: radius,
      backgroundColor: colorScheme.surfaceContainerHighest,
      backgroundImage: hasUrl
          ? CachedNetworkImageProvider(photoUrl!.trim())
          : AssetImage(AppAssets.profile),
    );
  }
}
