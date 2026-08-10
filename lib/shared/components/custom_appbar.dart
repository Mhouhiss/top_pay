import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:top_pay/core/theme/app_text_styles.dart';
import 'package:top_pay/core/constants/app_sizes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final String? subtitle;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final double scrolledUnderElevation;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.centerTitle = false,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.scrolledUnderElevation = 1,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;

    final bg =
        backgroundColor ??
        appBarTheme.backgroundColor ??
        theme.colorScheme.surface;

    final fg =
        foregroundColor ??
        appBarTheme.foregroundColor ??
        theme.colorScheme.onSurface;

    return AppBar(
      backgroundColor: bg,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      centerTitle: centerTitle,
      foregroundColor: fg,
      iconTheme: IconThemeData(color: fg),
      leading: leading ?? _buildLeading(context),
      title:
          titleWidget ??
          (title == null
              ? null
              : Column(
                  crossAxisAlignment: centerTitle
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppTextStyles.appBarTitle.copyWith(color: fg),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppTextStyles.appBarSubtitle.copyWith(
                          color: fg.withValues(alpha: 0.7),
                        ),
                      ),
                  ],
                )),
      actions: actions == null
          ? null
          : [...actions!, const SizedBox(width: AppSizes.sm)],
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (!showBackButton || !context.canPop()) {
      return null;
    }

    return IconButton(
      onPressed: onBackPressed ?? () => context.pop(),
      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
    );
  }
}
