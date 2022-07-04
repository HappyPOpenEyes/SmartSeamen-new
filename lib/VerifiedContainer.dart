// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'constants.dart';

class VerifiedContainer extends StatelessWidget {
  var height, width;

  VerifiedContainer({this.height, this.width});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: width,
      height: height,
      child: CircleAvatar(
          foregroundColor: kgreenPrimaryColor,
          backgroundColor: kgreenPrimaryColor,
          //
          // decoration: BoxDecoration(
          //     color: kgreenPrimaryColor,
          //     border: Border.all(
          //       color: kgreenPrimaryColor,
          //     ),
          //     borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Image.asset(
              'images/tick.png',
              color: kbackgroundColor,
            ),
          )),
    );
  }
}
