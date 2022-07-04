// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'ResumeBuilder/PersonalInformation/ResumeBuilder.dart';
import 'constants.dart';

class AnimatedText extends StatelessWidget {
  late AnimationController animationController;
  late int index;
  AnimatedText(
      {Key? key, required this.animationController, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FadeTransition(
      opacity: animationController,
      child: InkWell(
        onTap: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ResumeBuilder())),
        child: Container(
          decoration: BoxDecoration(
            color: kgreenPrimaryColor,
            border: Border.all(
              color: kgreenPrimaryColor,
            ),
            //borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          width: MediaQuery.of(context).size.width,
          height: index == 0
              ? MediaQuery.of(context).size.height * 0.075
              : MediaQuery.of(context).size.height * 0.1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
                index == 0
                    ? 'Your resume builder is not published yet. Click here to complete resume builder.'
                    : 'Please complete your profile by entering Security Questions. This will help you recover your account if you lose access.',
                style: const TextStyle(
                  color: kbackgroundColor,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
      ),
    );
  }
}
