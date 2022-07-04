// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'constants.dart';

class TextBoxLabel extends StatelessWidget {
  late String lable;
  TextBoxLabel(label, {super.key}) {
    this.lable = label;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Positioned(
        top: 0.0,
        left: 24.0,
        child: Container(
          color: Colors.white,
          child:   Text(
            "   $lable  ",
            style: const TextStyle(
                fontSize: 13.0,
                color: kblackPrimaryColor,
                fontWeight: FontWeight.bold),
          ),
        ));
  }
}
