import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../../../core/constants/app_sizes.dart';

class ContactPickerButton extends StatelessWidget {
  final ValueChanged<String> onPhoneSelected;
  final String Function(String) normalisePhone;

  const ContactPickerButton({
    super.key,
    required this.onPhoneSelected,
    required this.normalisePhone,
  });

  Future<void> _pickContact(BuildContext context) async {
    try {
      final permission = await FlutterContacts.permissions.request(
        PermissionType.read,
      );

      if (!context.mounted) return;

      if (permission != PermissionStatus.granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contacts permission is required.')),
        );
        return;
      }

      final contact = await FlutterContacts.native.showPicker(
        properties: {ContactProperty.phone},
      );

      if (!context.mounted || contact == null) return;

      if (contact.phones.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This contact has no phone number.')),
        );
        return;
      }

      onPhoneSelected(normalisePhone(contact.phones.first.number));
    } catch (e, stackTrace) {
      debugPrint('Contact picker error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to select contact. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Choose contact',
      onPressed: () => _pickContact(context),
      icon: const Icon(Icons.contacts_outlined),
      iconSize: AppSizes.iconMd,
    );
  }
}
