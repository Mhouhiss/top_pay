import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:top_pay/core/constants/app_assets.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.photoUrl,
    this.radius = 22.0,
    this.backgroundColor,
  });

  final String? photoUrl;
  final double radius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final hasUrl = photoUrl?.trim().isNotEmpty == true;

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? colorScheme.surfaceContainerHighest,
      backgroundImage: hasUrl
          ? CachedNetworkImageProvider(photoUrl!.trim())
          : AssetImage(AppAssets.userAvatar),
    );
  }
}
