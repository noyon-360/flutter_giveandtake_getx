import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controller/description_controller.dart';

class Bio extends StatelessWidget {
  const Bio({
    super.key,
    required TextEditingController descriptionTController,
    required this.descriptionController,
  }) : _descriptionTController = descriptionTController;

  final TextEditingController _descriptionTController;
  final DescriptionController descriptionController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About me',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF000000),
          ),
        ),

        SizedBox(height: 4),
        TextField(
          controller: _descriptionTController,
          maxLines: 8,
          minLines: 3,
          inputFormatters: [
            TextInputFormatter.withFunction((oldValue, newValue) {
              int newWords = descriptionController.countWords(newValue.text);
              if (newWords > descriptionController.maxWords) {
                // Return old value if exceeding max words.
                // You can also handle partial paste truncation here if desired.
                return oldValue;
              }
              return newValue;
            }),
          ],
          onChanged: (value) {
            descriptionController.wordCount.value = descriptionController.countWords(value);
          },

          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            hintText:
            'Write your description (max 400 words)',
            hintStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF787878),
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              //  Makes it circular
              borderSide:
              BorderSide.none, // Removes border line
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              //Circular when enabled
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              // Circular when focused
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Obx(
              () =>
              Text(
                '${descriptionController.wordCount
                    .value} / ${descriptionController
                    .maxWords} words',
                style: TextStyle(
                  fontSize: 12,
                  color:
                  descriptionController.wordCount.value >
                      descriptionController.maxWords
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
        ),
      ],
    );
  }
}