import 'package:flutter/material.dart';
import 'package:slider_captcha/presentation/screens/slider_captcha.dart';
import 'package:slider_captcha/presentation/widgets/captchar.dart';
import '../pizzule_path.dart';
import '../slide.dart';

class SliderPanel extends StatelessWidget {
  const SliderPanel({required this.image, this.sizeCaptcha = 50, Key? key})
      : super(key: key);

  final Image image;

  final double sizeCaptcha;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
         ClipPath(child: image),
         Slide( x: 150,y: 5, image: image, sizeCaptcha: sizeCaptcha,),
         CaptChar(image: image, x: 150, y: 50, percent: 50, sizeCaptcha: sizeCaptcha)
      ],
    );
  }

  // _background(context),
  // _slice(context, x, y),
  // _captcha(context, x, y, percent),

  // Widget _background(BuildContext context) {
  //   return Positioned(
  //     top: 0,
  //     width: MediaQuery.of(context).size.width,
  //     left: 0,
  //     child: ClipPath(child: image),
  //   );
  // }

  Widget _slice(BuildContext context, double x, double y) {
    return Positioned(
      top: 0,
      width: MediaQuery.of(context).size.width,
      left: 0,
      child: ClipPath(
        child: CustomPaint(
            foregroundPainter: PuzzlePiecePainter(
                sizeCaptcha, sizeCaptcha, x, y,
                paintingStyle: PaintingStyle.fill),
            child: image),
      ),
    );
  }

  Widget _captcha(BuildContext context, double x, double y, double percent) {
    return Positioned(
      top: 0,
      width: MediaQuery.of(context).size.width,
      left: percent,
      child: ClipPath(
        child: CustomPaint(
            foregroundPainter:
                PuzzlePiecePainter(sizeCaptcha, sizeCaptcha, x, y),
            child: image),
        clipper: PuzzlePieceClipper(sizeCaptcha, sizeCaptcha, x, y),
      ),
    );
  }
}