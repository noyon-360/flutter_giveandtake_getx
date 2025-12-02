import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/recruiter_account/presentation/widgets/searchable_bottom_sheet.dart';

class SearchableDropdown extends StatelessWidget {
  final String title;
  final List<String> items;
  final String selectedValue;
  final Function(String) onSelect;
  final InputDecoration decoration;

  const SearchableDropdown({
    super.key,
    required this.title,
    required this.items,
    required this.selectedValue,
    required this.onSelect,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SearchableBottomSheet(
          context,
          title: title,
          items: items,
          onSelect: (value) {
            onSelect(value);
          },
        );
      },
      child: AbsorbPointer(
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          value: selectedValue.isEmpty ? null : selectedValue,
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
        ),
      ),
    );
  }
}
