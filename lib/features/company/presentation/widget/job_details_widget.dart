import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobTextField extends StatelessWidget {
  final String label;
  final String hint;
  final RxString value;
  final int maxLines;

  const JobTextField({
    super.key,
    required this.label,
    required this.value,
    this.hint = "",
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15,),
        ),
        const SizedBox(height: 6),
        Obx(
          () => TextField(
            controller: TextEditingController(text: value.value)
              ..selection = TextSelection.collapsed(offset: value.value.length),
            onChanged: (val) => value.value = val,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Color(0xFFD9D9D9),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Color(0xFF484848)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
