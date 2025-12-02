import 'package:flutter/material.dart';
Widget buildDescriptionField(TextEditingController controller) {
  return TextField(
    controller: controller,
    maxLines: 6,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.grey[100],
    ),
  );
}