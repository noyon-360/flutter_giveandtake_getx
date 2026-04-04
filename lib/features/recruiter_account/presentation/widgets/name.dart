import 'package:flutter/material.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:giveandtake/core/theme/input_decoration_extensions.dart';

class Name extends StatelessWidget {
  const Name({
    super.key,
    required TextEditingController firstNameTEController,
    required FocusNode firstNameFocusNode,
    required TextEditingController surNameTEController,
    required FocusNode surNameFocusNode,
  }) : _firstNameTEController = firstNameTEController,
       _firstNameFocusNode = firstNameFocusNode,
       _surNameTEController = surNameTEController,
       _surNameFocusNode = surNameFocusNode;

  final TextEditingController _firstNameTEController;
  final FocusNode _firstNameFocusNode;
  final TextEditingController _surNameTEController;
  final FocusNode _surNameFocusNode;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'First Name*',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 6),
              TextFormField(
                controller: _firstNameTEController,
                focusNode: _firstNameFocusNode,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: context.primaryInputDecoration.copyWith(
                  hintText: "Enter your first name",
                  hintStyle: TextStyle(
                    color: Color(0xFF787878),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),

        SizedBox(width: 19),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Surname (Optional)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 6),
              TextFormField(
                controller: _surNameTEController,
                keyboardType: TextInputType.name,
                focusNode: _surNameFocusNode,
                textInputAction: TextInputAction.next,
                decoration: context.primaryInputDecoration.copyWith(
                  hintText: "Enter your surname",
                  hintStyle: TextStyle(
                    color: Color(0xFF787878),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
