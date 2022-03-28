import 'package:flutter/material.dart';
import 'package:slider_captcha/presentation/widgets/pizzule_path.dart';

class Slide extends StatelessWidget {
  const Slide(
      {required this.image,
      required this.sizeCaptcha,
      required this.x,
      required this.y,
      Key? key})
      : super(key: key);

  final double sizeCaptcha;

  final Image image;

  final double x;

  final double y;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: CustomPaint(
          foregroundPainter: PuzzlePiecePainter(
              sizeCaptcha, sizeCaptcha, x, y,
              paintingStyle: PaintingStyle.fill),
          child: image),
    );
  }
}
