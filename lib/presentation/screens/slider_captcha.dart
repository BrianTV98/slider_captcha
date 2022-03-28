import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:slider_captcha/logic/slider_controller.dart';
import 'package:slider_captcha/presentation/widgets/pizzule_path.dart';

import '../widgets/standard/slider_bar.dart';
import '../widgets/standard/slider_panel.dart';

class SliderCaptcha extends StatelessWidget {
  const SliderCaptcha(
      {required this.image,
      required this.onSuccess,
      this.title = 'Slide to authenticate',
      this.titleStyle,
      this.captchaSize = 30,
      Key? key})
      : super(key: key);

  final Image image;

  final void Function() onSuccess;

  final String title;

  final TextStyle? titleStyle;

  final double captchaSize;

  @override
  Widget build(BuildContext context) {
    SliderController _sliderController = SliderController();
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              height: 200,
              child: SliderPanel(sizeCaptcha: captchaSize, image: image)),
          SliderBar(title: 'àdfa', sliderController: _sliderController,)
          // SliderBar(
          //   title: title,
          //   titleStyle: titleStyle,
          // ),
        ],
      ),
    );
  }
}
