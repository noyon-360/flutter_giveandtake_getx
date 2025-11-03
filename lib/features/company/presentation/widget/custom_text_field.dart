import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int maxLines;
  final bool isRequired;
  

  // Styling
  final double fontSize;
  final Color labelColor;
  final Color hintColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color backgroundColor;
  final double borderRadius;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.isRequired = false,
    this.fontSize = 12,
    this.labelColor = const Color(0xFF2A2A2A),
    this.hintColor = const Color(0xFF707070),
    this.borderColor = const Color(0xFF484848),
    this.focusedBorderColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.borderRadius = 8,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  late bool _isLocalController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _isLocalController = false;
    } else {
      _controller = TextEditingController();
      _isLocalController = true;
    }
  }

  @override
  void dispose() {
    if (_isLocalController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            widget.isRequired ? "${widget.label} *" : widget.label,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w400,
              color: widget.labelColor,
            ),
          ),
          const SizedBox(height: 6),
          // TextField
          TextFormField(
            controller: _controller,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            validator: (value) {
              if (widget.isRequired && (value == null || value.isEmpty)) {
                return '${widget.label} is required';
              }
              return null;
            },
            style: TextStyle(
              fontSize: widget.fontSize,
              color: Color(0xFF2A2A2A),
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: widget.fontSize,
                color: widget.hintColor,
              ),
              filled: true,
              fillColor: widget.backgroundColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: widget.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color: widget.focusedBorderColor,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
