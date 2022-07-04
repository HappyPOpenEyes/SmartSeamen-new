// ignore_for_file: must_be_immutable

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smartseaman/constants.dart';

class BlurryDialogSingle extends StatelessWidget {
  String title;
  String content;

  BlurryDialogSingle(this.title, this.content, {Key? key}) : super(key: key);
  TextStyle textStyle = const TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all( Radius.circular(10)),
          ),
          title: Text(
            title,
            style: textStyle,
          ),
          content: Text(
            content,
            style: textStyle,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: kbackgroundColor,
                  //width: double.maxFinite,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: buttonStyle(),
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            )
          ],
        ));
  }
}
