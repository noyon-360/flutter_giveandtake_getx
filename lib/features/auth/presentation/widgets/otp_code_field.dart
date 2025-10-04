import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/theme/app_colors.dart';

class PinCode extends StatefulWidget {
  const PinCode({super.key, required this.otpController});

  final TextEditingController otpController;

  @override
  State<PinCode> createState() => _PinCodeState();
}

class _PinCodeState extends State<PinCode> {
  StreamController<ErrorAnimationType>? errorController;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      controller: widget.otpController,
      length: 6,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      autoFocus: false,
      onChanged: (value) {
        // This callback is REQUIRED to prevent RangeError
        // when using length > 4 with pin_code_fields package v8.0.1
      },
      errorAnimationController: errorController,
      obscureText: false,
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),

      cursorColor: Colors.black,
      enableActiveFill: true,

      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(6),
        fieldHeight: 56,
        fieldWidth: 54,

        //  reduce the spacing here
        // default ~16, reduce to make boxes closer
        inactiveColor: Colors.grey,
        activeColor: Colors.black,
        selectedColor: Colors.black,

        inactiveFillColor: AppColors.primaryWhite,
        activeFillColor: AppColors.primaryWhite,
        selectedFillColor: AppColors.primaryWhite,
      ),
    );
  }
}
