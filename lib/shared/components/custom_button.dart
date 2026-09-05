// import 'package:flutter/material.dart';
// import 'package:top_pay/core/constants/app_sizes.dart';
//
// class CustomButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed;
//   final bool enabled;
//   final bool isLoading;
//   final Widget? icon;
//   final double? width;
//   final double? height;
//   final Color? backgroundColor;
//   final Color? foregroundColor;
//   final BorderRadius? borderRadius;
//
//   const CustomButton({
//     super.key,
//     required this.text,
//     this.onPressed,
//     this.enabled = true,
//     this.isLoading = false,
//     this.icon,
//     this.width,
//     this.height,
//     this.backgroundColor,
//     this.foregroundColor,
//     this.borderRadius,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final disabled = !enabled || onPressed == null || isLoading;
//
//     final child = isLoading
//         ? SizedBox(
//             height: AppSizes.iconMd,
//             width: AppSizes.iconMd,
//             child: CircularProgressIndicator(
//               strokeWidth: 2.5,
//               color:
//                   foregroundColor ??
//                   theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}),
//             ),
//           )
//         : Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               if (icon != null) ...[icon!, const SizedBox(width: AppSizes.sm)],
//               Text(text),
//             ],
//           );
//
//     return SizedBox(
//       width: width,
//       height: height ?? AppSizes.buttonHeight,
//       child: ElevatedButton(
//         onPressed: disabled ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: backgroundColor,
//           foregroundColor: foregroundColor,
//           shape: RoundedRectangleBorder(
//             borderRadius:
//                 borderRadius ?? BorderRadius.circular(AppSizes.radiusSm),
//           ),
//         ),
//         child: child,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:top_pay/core/constants/app_sizes.dart';

enum ButtonVariant { primary, secondary, outline, text }

enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool fullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? textColor;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.textColor,
    this.backgroundColor,
    this.borderRadius,
  });

  const CustomButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.size = ButtonSize.medium,
    this.borderRadius,
    this.textColor,
    this.backgroundColor,
  }) : variant = ButtonVariant.primary;

  const CustomButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.size = ButtonSize.medium,
    this.borderRadius,
    this.textColor,
    this.backgroundColor,
  }) : variant = ButtonVariant.secondary;

  const CustomButton.outline({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.size = ButtonSize.medium,
    this.borderRadius,
    this.textColor,
    this.backgroundColor,
  }) : variant = ButtonVariant.outline;

  const CustomButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.fullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
    this.size = ButtonSize.medium,
    this.borderRadius,
    this.textColor,
    this.backgroundColor,
  }) : variant = ButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final labelStyle = _getTextStyle(context);
    final isDisabled = onPressed == null || isLoading;

    final fgColor = variant == ButtonVariant.primary
        ? (textColor ?? scheme.onPrimary)
        : (textColor ?? scheme.primary);

    final textStyle = labelStyle?.copyWith(
      color: isDisabled && variant == ButtonVariant.primary
          ? fgColor.withValues(alpha: 0.7)
          : fgColor,
      fontWeight: FontWeight.w600,
    );

    Widget content = isLoading
        ? SizedBox(
            height: _iconSize,
            width: _iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color:
                  variant == ButtonVariant.outline ||
                      variant == ButtonVariant.text
                  ? scheme.primary
                  : scheme.onPrimary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: AppSizes.iconSm, color: fgColor),
                const SizedBox(width: AppSizes.sm),
              ],
              Text(label, style: textStyle),
              if (trailingIcon != null) ...[
                const SizedBox(width: AppSizes.sm),
                Icon(trailingIcon, size: AppSizes.iconSm),
              ],
            ],
          );

    final shape = RoundedRectangleBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.radiusMd),
    );
    final minSize = Size(fullWidth ? double.infinity : 0, _height);

    Widget button;
    switch (variant) {
      case ButtonVariant.primary:
        button = ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? scheme.primary,
            foregroundColor: textColor ?? scheme.onPrimary,
            disabledBackgroundColor: scheme.primary.withValues(alpha: 0.4),
            minimumSize: minSize,
            shape: shape,
          ),
          child: content,
        );
        break;
      case ButtonVariant.secondary:
        button = ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                backgroundColor ?? scheme.primary.withValues(alpha: 0.1),
            foregroundColor: textColor ?? scheme.primary,
            elevation: 0,
            minimumSize: minSize,
            shape: shape,
          ),
          child: content,
        );
        break;
      case ButtonVariant.outline:
        button = OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? scheme.primary,
            side: BorderSide(
              color:
                  backgroundColor ??
                  (isDisabled ? scheme.outlineVariant : scheme.primary),
            ),
            minimumSize: minSize,
            shape: shape,
          ),
          child: content,
        );
        break;
      case ButtonVariant.text:
        button = TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? scheme.primary,
            minimumSize: minSize,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
          ),
          child: content,
        );
        break;
    }
    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }

  double get _height {
    switch (size) {
      case ButtonSize.small:
        return AppSizes.smButtonHeight;
      case ButtonSize.medium:
        return AppSizes.mdButtonHeight;
      case ButtonSize.large:
        return AppSizes.lgButtonHeight;
    }
  }

  TextStyle? _getTextStyle(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    switch (size) {
      case ButtonSize.small:
        return textTheme.labelSmall;
      case ButtonSize.medium:
        return textTheme.labelMedium;
      case ButtonSize.large:
        return textTheme.labelLarge;
    }
  }

  double get _iconSize {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }
}
