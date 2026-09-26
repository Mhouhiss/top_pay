import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/core/router/router.dart';

class Services extends StatelessWidget {
  const Services({super.key});

  static const List<ServiceCategory> _services = [
    ServiceCategory(
      title: 'Airtime',
      icon: Icons.phone_android_outlined,
      route: AppRoutes.airtime,
    ),
    ServiceCategory(
      title: 'Data',
      icon: Icons.wifi_outlined,
      route: AppRoutes.data,
    ),
    ServiceCategory(
      title: 'Cable TV',
      icon: Icons.live_tv_outlined,
      route: AppRoutes.cableTv,
    ),
    ServiceCategory(
      title: 'Electricity',
      icon: Icons.lightbulb_outline_rounded,
      route: AppRoutes.electricity,
    ),
    ServiceCategory(
      title: 'Education',
      icon: Icons.school_outlined,
      route: AppRoutes.education,
    ),
    ServiceCategory(
      title: 'Betting',
      icon: Icons.sports_soccer_outlined,
      route: AppRoutes.betting,
    ),
    ServiceCategory(
      title: 'Cards',
      icon: Icons.credit_card_outlined,
      route: AppRoutes.cards,
    ),
    ServiceCategory(
      title: 'More',
      icon: Icons.grid_view_outlined,
      route: AppRoutes.services,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _services.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 4,
        childAspectRatio: 0.82,
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              service.icon,
              size: 27,
              color: colorScheme.onPrimaryContainer,
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
  final IconData icon;
  final String route;
}
