import 'package:flutter/material.dart';

import 'constants.dart';

class EditableVerifiedContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.02,
      color: kgreenPrimaryColor,
      child: Center(
        child: Text(
          'Verified',
          style: TextStyle(color: kbackgroundColor),
        ),
      ),
    );
  }
}
