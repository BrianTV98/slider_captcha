import 'package:flutter/material.dart';
import 'package:slider_captcha/presentation/widgets/slide.dart';

class CaptChar extends StatelessWidget {
  const CaptChar({required this.image,
    required this.x,
    required this.y,
    required this.percent,
    required this.sizeCaptcha, Key? key}) : super(key: key);

  final double sizeCaptcha;

  final double x;

  final double y;

  final Image image;

  final double percent;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      width: MediaQuery.of(context).size.width,
      left: percent,
      child: Slide(sizeCaptcha: sizeCaptcha, x: x, y: y, image: image,),
    );
  }
}
