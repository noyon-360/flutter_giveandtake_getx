

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdownJobField extends StatefulWidget {
  final String label;
  final String hintText;
  final String? value;
  final RxString? rxValue;
  final List<String>? items;
  final bool isRequired;
  final bool isDatePicker;
  final TextEditingController? controller;
  final Function(String?)? onChanged;
  final bool enabled; // ✅ NEW: controls whether dropdown is active

  // Styling
  final double fontSize;
  final Color labelColor;
  final Color hintColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color backgroundColor;
  final double borderRadius;

  const CustomDropdownJobField({
    super.key,
    required this.label,
    required this.hintText,
    this.value,
    this.rxValue,
    this.items,
    this.controller,
    this.onChanged,
    this.isRequired = false,
    this.isDatePicker = false,
    this.fontSize = 12,
    this.labelColor = const Color(0xFF2A2A2A),
    this.hintColor = const Color(0xFF707070),
    this.borderColor = const Color(0xFF484848),
    this.focusedBorderColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.borderRadius = 8,
    this.enabled = true, // ✅ default = true
  });

  @override
  State<CustomDropdownJobField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownJobField> {
  @override
  void initState() {
    super.initState();

    // Sync RxString with controller (if provided)
    if (widget.rxValue != null &&
        widget.controller != null &&
        widget.controller!.text.isNotEmpty) {
      widget.rxValue!.value = widget.controller!.text;
    }
    widget.controller?.addListener(() {
      if (widget.rxValue != null) {
        widget.rxValue!.value = widget.controller!.text;
      }
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = "${picked.day}-${picked.month}-${picked.year}";
      if (widget.rxValue != null) widget.rxValue!.value = formattedDate;
      widget.controller?.text = formattedDate;
      widget.onChanged?.call(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rxValue != null) {
      return Obx(() {
        final currentValue = widget.controller?.text.isNotEmpty == true
            ? widget.controller!.text
            : (widget.rxValue!.value.isEmpty ? null : widget.rxValue!.value);
        return _buildDropdown(currentValue);
      });
    } else {
      final currentValue = widget.controller?.text.isNotEmpty == true
          ? widget.controller!.text
          : (widget.value?.isEmpty ?? true ? null : widget.value);
      return _buildDropdown(currentValue);
    }
  }

  Widget _buildDropdown(String? currentValue) {
    // Date Picker Mode
    if (widget.isDatePicker) {
      return GestureDetector(
        onTap: widget.enabled ? _pickDate : null,
        child: InputDecorator(
          decoration: _inputDecoration(),
          child: Text(
            currentValue ?? widget.hintText,
            style: TextStyle(
              fontSize: widget.fontSize,
              color: widget.enabled
                  ? (currentValue != null ? Colors.black : widget.hintColor)
                  : Colors.grey,
            ),
          ),
        ),
      );
    }

    // Normal Dropdown Mode
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isRequired ? "${widget.label} *" : widget.label,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w500,
              color: widget.enabled ? widget.labelColor : Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            isExpanded: true,
            value: (widget.items?.contains(currentValue) ?? false)
                ? currentValue
                : null,
            onChanged: widget.enabled
                ? (val) {
                    if (widget.rxValue != null)
                      widget.rxValue!.value = val ?? '';
                    widget.controller?.text = val ?? '';
                    widget.onChanged?.call(val);
                  }
                : null, // ✅ disables dropdown when false
            decoration: _inputDecoration(),
            hint: Text(
              widget.hintText,
              style: TextStyle(
                fontSize: widget.fontSize,
                color: widget.enabled ? widget.hintColor : Colors.grey,
              ),
            ),
            items:
                widget.items
                    ?.map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: widget.fontSize,
                            color: widget.enabled ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    )
                    .toList() ??
                [],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: widget.enabled
          ? widget.backgroundColor
          : Colors.grey.shade200, // ✅ greyed background
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(color: widget.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(color: widget.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(color: widget.focusedBorderColor, width: 2),
      ),
    );
  }
}
