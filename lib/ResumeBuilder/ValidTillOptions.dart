// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../constants.dart';

class ValidTillOptions extends StatelessWidget {
  bool radioValue = false;
  String text = "";

  ValidTillOptions({Key? key, required this.radioValue, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        radioValue
            ? const Icon(
                Icons.radio_button_checked,
                color: kgreenPrimaryColor,
              )
            : const Icon(
                Icons.radio_button_unchecked,
                color: kgreenPrimaryColor,
              ),
        const SizedBox(
          width: 5,
        ),
        Text(text),
      ],
    );
  }
}
