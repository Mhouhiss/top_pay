import 'package:flutter/material.dart';
import 'package:top_pay/core/theme/app_colors.dart';

class CustomDropdownItem<T> {
  final T value;
  final String label;
  final Widget? leading;

  const CustomDropdownItem({
    required this.value,
    required this.label,
    this.leading,
  });
}

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<CustomDropdownItem<T>> items;
  final void Function(T?) onChanged;
  final String? hint;
  final String? Function(T?)? validator;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          initialValue: value,
          validator: validator,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textSecondaryLight,
          ),
          decoration: InputDecoration(hintText: hint),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item.value,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (item.leading != null) ...[
                        item.leading!,
                        const SizedBox(width: 8),
                      ],
                      Text(item.label),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
