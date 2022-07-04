import 'package:flutter/material.dart';

class DisplayChips extends StatelessWidget {
  List<Widget> chipList;
  DisplayChips({required this.chipList});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Wrap(
      children: chipList,
    );
  }
}
