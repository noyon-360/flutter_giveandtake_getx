import 'package:flutter/material.dart';
import 'package:karlfive/core/theme/app_colors.dart';

class JobFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;

  const JobFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? AppColors.primaryBlue)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (selectedColor ?? AppColors.primaryBlue)
                : AppColors.textGrey.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textBlack,
          ),
        ),
      ),
    );
  }
}

class JobFiltersRow extends StatelessWidget {
  final List<String> selectedFilters;
  final Function(String) onFilterToggle;

  const JobFiltersRow({
    super.key,
    required this.selectedFilters,
    required this.onFilterToggle,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filters = [
      {'label': 'Jobs', 'color': AppColors.primaryBlue},
      {'label': 'Date posted', 'color': AppColors.primaryBlue},
      {'label': 'Job Type', 'color': null},
      {'label': 'Date posted', 'color': null},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Filter icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.textGrey.withOpacity(0.3)),
            ),
            child: const Icon(Icons.tune, size: 20, color: AppColors.textBlack),
          ),

          const SizedBox(width: 12),

          // Filter chips
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filters.map((filter) {
                  return JobFilterChip(
                    label: filter['label'],
                    isSelected: selectedFilters.contains(filter['label']),
                    selectedColor: filter['color'],
                    onTap: () => onFilterToggle(filter['label']),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
