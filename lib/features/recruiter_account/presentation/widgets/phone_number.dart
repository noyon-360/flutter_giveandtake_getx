import 'package:flutter/material.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:karlfive/core/theme/input_decoration_extensions.dart';

class PhoneNumberAndEmail extends StatelessWidget {
  const PhoneNumberAndEmail({
    super.key,
    required TextEditingController emailTEController,
    required FocusNode emailFocusNode,
  }) : _emailTEController = emailTEController, _emailFocusNode = emailFocusNode;

  final TextEditingController _emailTEController;
  final FocusNode _emailFocusNode;

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
                'Email Address*',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 6),
              TextFormField(
                controller: _emailTEController,
                focusNode: _emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: context.primaryInputDecoration.copyWith(
                  hintText: "Enter Your Email",
                  hintStyle: TextStyle(
                    color: Color(0xFF787878),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                validator: Validators.email,
              ),
            ],
          ),
        ),
      ],
    );
  }
}