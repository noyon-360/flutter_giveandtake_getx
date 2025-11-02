import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DynamicListField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final RxList<String> items;
  final VoidCallback onAdd;

  const DynamicListField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.items,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onAdd,
              child: const Text("Add more +"),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items
                  .asMap()
                  .entries
                  .map(
                    (entry) => ListTile(
                      title: Text(entry.value),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => items.removeAt(entry.key),
                      ),
                    ),
                  )
                  .toList(),
            )),
      ],
    );
  }
}
