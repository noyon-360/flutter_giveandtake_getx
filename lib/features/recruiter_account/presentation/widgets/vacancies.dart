import 'package:flutter/material.dart';

import '../../../../core/theme/input_decoration_extensions.dart';
import '../controller/job_posting_controller.dart';

class Vacancy extends StatelessWidget {
  const Vacancy({
    super.key,
    required TextEditingController vacanciesTEController,
    required FocusNode vacanciesFocusNode,
    required this.controller,
  }) : _vacanciesTEController = vacanciesTEController, _vacanciesFocusNode = vacanciesFocusNode;

  final TextEditingController _vacanciesTEController;
  final FocusNode _vacanciesFocusNode;
  final JobPostingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: _vacanciesTEController,
        focusNode: _vacanciesFocusNode,
        onChanged: (value) => controller.vacancies.value = value,
        keyboardType: TextInputType.number,
        decoration: context.primaryInputDecoration.copyWith(
          hintText: _vacanciesTEController.text,
          suffixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              //Increment Button
              GestureDetector(
                onTap: () {
                  int value =
                      int.tryParse(_vacanciesTEController.text) ?? 0;
                  if (value < 50) {
                    value++;
                    _vacanciesTEController.text = value.toString();
                    controller.vacancies.value = value
                        .toString(); // update the observable
                  }
                },
                child: Container(
                  height: 17,
                  width: 22,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_drop_up,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 3),
              //Removed SizedBox, now only 1-pixel border gap
              GestureDetector(
                onTap: () {
                  int value =
                      int.tryParse(_vacanciesTEController.text) ?? 0;
                  if (value > 1) {
                    value--;
                    _vacanciesTEController.text = value.toString();
                    controller.vacancies.value = value
                        .toString(); // update the observable
                  }
                },
                child: Container(
                  height: 17,
                  width: 22,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          hintStyle: const TextStyle(
            color: Color(0xFF787878),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}