import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/core/router/router.dart';
import 'package:top_pay/core/constants/app_assets.dart';

class Services extends StatelessWidget {
  const Services({super.key});

  static const List<ServiceCategory> _services = [
    ServiceCategory(
      title: 'Airtime',
      icon: AppAssets.airtime,
      route: AppRoutes.airtime,
    ),
    ServiceCategory(title: 'Data', icon: AppAssets.data, route: AppRoutes.data),
    ServiceCategory(
      title: 'Cable TV',
      icon: AppAssets.tv,
      route: AppRoutes.cableTv,
    ),
    ServiceCategory(
      title: 'Electricity',
      icon: AppAssets.electricity,
      route: AppRoutes.electricity,
    ),
    ServiceCategory(
      title: 'Education',
      icon: AppAssets.education,
      route: AppRoutes.education,
    ),
    ServiceCategory(
      title: 'Betting',
      icon: AppAssets.betting,
      route: AppRoutes.betting,
    ),
    ServiceCategory(
      title: 'Cards',
      icon: AppAssets.card,
      route: AppRoutes.cards,
    ),
    ServiceCategory(
      title: 'More',
      icon: AppAssets.more,
      route: AppRoutes.services,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _services.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        mainAxisSpacing: 8,
        crossAxisSpacing: 4,
        mainAxisExtent: 85,
      ),
      itemBuilder: (context, index) {
        final service = _services[index];
        return _ServiceItem(
          service: service,
          onTap: () {
            context.push(service.route);
          },
        );
      },
    );
  }
}

class _ServiceItem extends StatelessWidget {
  const _ServiceItem({required this.service, required this.onTap});

  final ServiceCategory service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final iconBg = isDark
        ? colorScheme.primaryContainer
        : colorScheme.primary.withValues(alpha: 0.1);
    final iconColor = isDark
        ? colorScheme.onPrimaryContainer
        : colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Image.asset(
              service.icon,
              width: 27,
              height: 27,
              color: iconColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            service.title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceCategory {
  const ServiceCategory({
    required this.title,
    required this.icon,
    required this.route,
  });

  final String title;
  final String icon;
  final String route;
}
