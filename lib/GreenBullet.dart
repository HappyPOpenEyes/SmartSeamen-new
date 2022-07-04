import 'package:flutter/material.dart';

import 'constants.dart';

class GreenBullet extends StatelessWidget {
  const GreenBullet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 7,
      height: 7,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: kgreenPrimaryColor,
      ),
    );
  }
}
