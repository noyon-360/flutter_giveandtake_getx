import 'package:flutter/material.dart';

class AwardsFormSection extends StatelessWidget {
  final int index;
  const AwardsFormSection({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index == 0) ...[
          const Text(
            'Awards & Honours',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
        ],
        if (index > 0) ...[Divider(thickness: 2), const SizedBox(height: 16)],
        TextField(
          decoration: InputDecoration(
            labelText: 'Award Title*',
            hintText: 'Write here',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Program Name*',
                  hintText: 'Write here',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Program Date*',
                  hintText: 'Write here',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Award Short Description*'),
        const SizedBox(height: 8),
        const TextField(
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Write here',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
