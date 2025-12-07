import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RequirementItem extends StatelessWidget {
  final String label;
  //final void Function(bool) onChanged;
  final RxString selectedStatus;
  final VoidCallback onDelete;

  const RequirementItem({
    required this.label,
    //required this.onChanged,
    required this.selectedStatus,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              // Rounded box instead of Checkbox
              GestureDetector(
                onTap: () => (){},
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFF2B7FD0),
                      width: 2,
                    ),
                    color: Color(0xFF2B7FD0),
                  ),
                  child: const Icon(Icons.check, size: 14, color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedStatus.value.isEmpty ? null : selectedStatus.value,
              hint: const Text("Set status", style: TextStyle(color: Colors.black),),
              items: const [
                DropdownMenuItem(value: "Required", child: Text("Required")),
                DropdownMenuItem(value: "Optional", child: Text("Optional")),
              ],
              onChanged: (val) {
                if (val != null) selectedStatus.value = val;
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete_forever_rounded, color: Colors.grey,),
          color: Colors.grey,
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Remove requirement'),
                content: Text('Remove "$label" from application requirements?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onDelete();
                    },
                    child: const Text('Remove'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ));

  }
}