import 'package:flutter/material.dart';
import 'package:top_pay/core/theme/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/formatters.dart';
import 'custom_button.dart';

/// Bottom-sheet date picker themed to match the app, used anywhere a date
/// needs picking (e.g. filtering transaction history, scheduling a
/// recurring bill payment).
///
/// Returns the selected [DateTime], or `null` if dismissed.
Future<DateTime?> showCalendarModal(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  String title = 'Select Date',
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSizes.radiusLg),
      ),
    ),
    builder: (context) => _CalendarModal(
      title: title,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime.now(),
    ),
  );
}

/// Same as [showCalendarModal] but lets the user pick a start/end range —
/// handy for "custom range" transaction history filters.
Future<DateTimeRange?> showCalendarRangeModal(
  BuildContext context, {
  DateTimeRange? initialRange,
  DateTime? firstDate,
  DateTime? lastDate,
  String title = 'Select Date Range',
}) {
  return showModalBottomSheet<DateTimeRange>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSizes.radiusLg),
      ),
    ),
    builder: (context) => _CalendarRangeModal(
      title: title,
      initialRange: initialRange,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime.now(),
    ),
  );
}

class _ModalChrome extends StatelessWidget {
  final String title;
  final Widget child;

  const _ModalChrome({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.md,
        right: AppSizes.md,
        top: AppSizes.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.only(bottom: AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSizes.sm),
          child,
        ],
      ),
    );
  }
}

class _CalendarModal extends StatefulWidget {
  final String title;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const _CalendarModal({
    required this.title,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<_CalendarModal> createState() => _CalendarModalState();
}

class _CalendarModalState extends State<_CalendarModal> {
  late DateTime _selected = widget.initialDate;

  @override
  Widget build(BuildContext context) {
    return _ModalChrome(
      title: widget.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.primary,
                onPrimary: Colors.white,
                onSurface: AppColors.textPrimaryLight,
              ),
            ),
            child: CalendarDatePicker(
              initialDate: _selected,
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              onDateChanged: (date) => setState(() => _selected = date),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          CustomButton.primary(
            label: 'Select ${Formatters.date(_selected)}',
            onPressed: () => Navigator.of(context).pop(_selected),
          ),
        ],
      ),
    );
  }
}

class _CalendarRangeModal extends StatefulWidget {
  final String title;
  final DateTimeRange? initialRange;
  final DateTime firstDate;
  final DateTime lastDate;

  const _CalendarRangeModal({
    required this.title,
    required this.initialRange,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<_CalendarRangeModal> createState() => _CalendarRangeModalState();
}

class _CalendarRangeModalState extends State<_CalendarRangeModal> {
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _start = widget.initialRange?.start;
    _end = widget.initialRange?.end;
  }

  void _onDayTap(DateTime day) {
    setState(() {
      if (_start == null || (_start != null && _end != null)) {
        _start = day;
        _end = null;
      } else if (day.isBefore(_start!)) {
        _start = day;
      } else {
        _end = day;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final canConfirm = _start != null && _end != null;

    return _ModalChrome(
      title: widget.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RangeLabel(label: 'From', date: _start),
              const Icon(
                Icons.arrow_forward,
                size: 16,
                color: AppColors.textSecondaryLight,
              ),
              _RangeLabel(label: 'To', date: _end),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.primary,
                onPrimary: Colors.white,
                onSurface: AppColors.textPrimaryLight,
              ),
            ),
            child: CalendarDatePicker(
              initialDate: _start ?? widget.lastDate,
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              onDateChanged: _onDayTap,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          CustomButton.primary(
            label: 'Apply Range',
            onPressed: canConfirm
                ? () => Navigator.of(
                    context,
                  ).pop(DateTimeRange(start: _start!, end: _end!))
                : null,
          ),
        ],
      ),
    );
  }
}

class _RangeLabel extends StatelessWidget {
  final String label;
  final DateTime? date;

  const _RangeLabel({required this.label, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondaryLight,
          ),
        ),
        Text(
          date == null ? '—' : Formatters.date(date!),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
