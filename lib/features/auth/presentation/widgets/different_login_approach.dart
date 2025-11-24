import 'package:flutter/material.dart';

class DifferentLoginApproach extends StatelessWidget {
  const DifferentLoginApproach({
    super.key,
    required this.image1,
    required this.image2,
  });
  final String image1;
  final String image2;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(width: 40, height: 40, image: AssetImage(image1)),
          SizedBox(width: 40),
          Image(width: 40, height: 40, image: AssetImage(image2)),
        ],
      ),
    );
  }
}
