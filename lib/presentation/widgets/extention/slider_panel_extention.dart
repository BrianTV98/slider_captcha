import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slider_captcha/logic/extention/slider_captcha_extension_cubit.dart';
import 'package:slider_captcha/presentation/widgets/extention/timer_title.dart';

import '../pizzule_path.dart';

class SliderPanelExtension extends StatelessWidget {
  const SliderPanelExtension(
      {required this.image, this.sizeCaptcha = 50, Key? key})
      : super(key: key);

  final Image image;

  final double sizeCaptcha;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [image, _slice(context), _captcha(context), _lockUI(context)],
    );
  }

  Widget _slice(BuildContext context) {
    return _SliderAdapter(
      child: (x, y, offsetX, offsetY) {
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
    );
  }

  Widget _captcha(BuildContext context) {
    return _SliderAdapter(
      child: (x, y, offsetX, offsetY) {
        return Positioned(
          top: offsetY - y,
          width: MediaQuery.of(context).size.width,
          left: offsetX - x,
          child: GestureDetector(
            onHorizontalDragStart: (DragStartDetails detail) {
              context.read<SliderCaptchaExtensionCubit>().move(
                  detail.localPosition.dx - x - sizeCaptcha / 2,
                  detail.localPosition.dy - y - sizeCaptcha / 2);
            },
            onHorizontalDragUpdate: (DragUpdateDetails detail) {
              context.read<SliderCaptchaExtensionCubit>().move(
                  detail.localPosition.dx - x - sizeCaptcha / 2,
                  detail.localPosition.dy - y - sizeCaptcha / 2);
            },
            onHorizontalDragEnd: (DragEndDetails detail) {
              context.read<SliderCaptchaExtensionCubit>().check();
            },
            child: ClipPath(
              child: CustomPaint(
                  foregroundPainter:
                      PuzzlePiecePainter(sizeCaptcha, sizeCaptcha, x, y),
                  child: image),
              clipper: PuzzlePieceClipper(sizeCaptcha, sizeCaptcha, x, y),
            ),
          ),
        );
      },
    );
  }

  Widget _lockUI(BuildContext context) {
    return BlocBuilder<SliderCaptchaExtensionCubit,
        SliderCaptchaExtensionState>(builder: (context, state) {
      debugPrint(state.toString());
      if (state is SliderCaptchaExtensionLock) {
        return AbsorbPointer(
          absorbing: true,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.8),
            child: const Center(
              child: TimerTitle(
                title: 'Vui lòng xác thực lại sau',
              ),
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }
}

class _SliderAdapter extends StatelessWidget {
  const _SliderAdapter({required this.child, this.reRender = false, Key? key})
      : super(key: key);

  final Widget Function(double x, double y, double offsetX, double offsetY)
      child;

  final bool reRender;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SliderCaptchaExtensionCubit,
        SliderCaptchaExtensionState>(
      builder: (context, state) {
        if (state is SliderCaptchaExtensionMove) {
          final bloc = BlocProvider.of<SliderCaptchaExtensionCubit>(context);

          return child(bloc.x, bloc.y, state.offsetX, state.offsetY);
        }
        return const SizedBox();
      },
    );
  }
}
