import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slider_captcha/logic/slider_captcha_cubit.dart';
import 'package:slider_captcha/presentation/widgets/pizzule_path.dart';

class SliderPanel extends StatelessWidget {
  const SliderPanel({required this.image, this.sizeCaptcha = 50, Key? key})
      : super(key: key);

  final Image image;

  final double sizeCaptcha;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        image,
        SliderAdapter(
          child: (x, y, percent) {
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
          },
        ),
        SliderAdapter(
          child: (x, y, percent) {
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
          },
        ),
      ],
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
        if (state is SliderCaptchaMove) {
          final bloc = BlocProvider.of<SliderCaptchaCubit>(context);
          return child(
              bloc.offsetX, bloc.offsetY, state.offsetMove - bloc.offsetX);
        }
        return const SizedBox();
      },
    );
  }
}
