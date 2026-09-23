import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:top_pay/core/constants/app_assets.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.photoUrl, this.radius = 20.0});

  final String? photoUrl;
  final double radius;

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
