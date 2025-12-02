import 'package:flutter/material.dart';

class ApplicationRequirementsWidget extends StatelessWidget {
  const ApplicationRequirementsWidget({super.key});

  BoxDecoration boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Application Requirements",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          Row(
            children: [
              Text("Resume", style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(width: 30),
              Text("Required", style: TextStyle(color: Colors.red)),
            ],
          ),

          SizedBox(height: 20),

          Row(
            children: [
              Text(
                "Valid visa for this job location?",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 30),
              Text("Optional", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
