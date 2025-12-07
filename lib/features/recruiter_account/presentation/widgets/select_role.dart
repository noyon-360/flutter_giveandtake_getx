import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/recruiter_account/presentation/widgets/searchable_bottom_sheet.dart';

class SearchableRoleDropdown extends StatelessWidget {
  final String title;
  final List<String> items;
  final RxString selectedValue;
  final String emptyMessage;
  final InputDecoration decoration;

  const SearchableRoleDropdown({
    super.key,
    required this.title,
    required this.items,
    required this.selectedValue,
    required this.emptyMessage,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (items.isEmpty) {
          Get.snackbar(
            'Select Category First',
            emptyMessage,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        SearchableBottomSheet(
          context,
          title: title,
          items: items,
          onSelect: (value) {
            selectedValue.value = value;
          },
        );
      },
      child: AbsorbPointer(
        child: Obx(() => DropdownButtonFormField<String>(
          isExpanded: true,
          value: selectedValue.value.isEmpty ? null : selectedValue.value,
          hint: Text(
            'Select $title',
            style: const TextStyle(color: Colors.grey),
          ),
          decoration: decoration,
          items: items
              .map(
                (item) => DropdownMenuItem(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
              .toList(),
          onChanged: (_) {},
        )),
      ),
    );
  }
}
