import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slider_captcha/logic/standard/slider_captcha_cubit.dart';

import '../pizzule_path.dart';

class SliderPanel extends StatelessWidget {

  const SliderPanel({required this.image, this.sizeCaptcha = 50, Key? key})
      : super(key: key);

  final Image image;

  final double sizeCaptcha;

  @override
  Widget build(BuildContext context) {
    return SliderAdapter(
      child: (x, y, percent) => Stack(
        children: [
          _background(context),
          _slice(context, x, y),
          _captcha(context, x, y, percent),
        ],
      ),
    );
  }

  Widget _background(BuildContext context) {
    return Positioned(
      top: 0,
      width: MediaQuery.of(context).size.width,
      left: 0,
      child: ClipPath(child: image),
    );
  }

  Widget _slice(BuildContext context, x, y) {
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


class SliderAdapter extends StatelessWidget {
  const SliderAdapter({required this.child, this.reRender = false, Key? key})
      : super(key: key);

  final Widget Function(double offsetX, double offsetY, double currentPosition)
      child;

  final bool reRender;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SliderCaptchaCubit, SliderCaptchaState>(
      builder: (context, state) {
        final bloc = BlocProvider.of<SliderCaptchaCubit>(context);
        return child(
            bloc.offsetX, bloc.offsetY,
            state.offsetMove - bloc.offsetX);
      },
      buildWhen: (pre, current) => current is! SliderCaptchaLock,
    );
  }
}
