import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slider_captcha/logic/standard/slider_captcha_cubit.dart';

class SliderBar extends StatelessWidget {
  const SliderBar({required this.title, this.height = 50, Key? key})
      : super(key: key);

  final String title;

  final double height;

  @override
  Widget build(BuildContext context) {
    return _OutlineBorder(
      height: height,
      child: Stack(
        children: <Widget>[_title(), _button()],
      ),
    );
  }

  Widget _button() {
    return BlocBuilder<SliderCaptchaCubit, SliderCaptchaState>(
      builder: (context, state) {
        return Positioned(
            left: state.offsetMove,
            top: 0,
            height: 50,
            width: 50,
            child: GestureDetector(
              onHorizontalDragStart: (DragStartDetails detail) {
                // widget.onchange(0);
              },
              onHorizontalDragUpdate: (DragUpdateDetails detail) {
                move(state, context, detail);
              },
              onHorizontalDragEnd: (DragEndDetails detail) {
                check(state, context, detail);
              },
              child: Container(
                height: height,
                width: height,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: const <BoxShadow>[
                      BoxShadow(color: Colors.grey, blurRadius: 4)
                    ]),
                child: const Icon(Icons.arrow_forward_rounded),
              ),
            ));
      },
    );
  }

  Widget _title() {
    return Center(
      child: Text(title, textAlign: TextAlign.center),
    );
  }

  void move(
    SliderCaptchaState state,
    BuildContext context,
    DragUpdateDetails detail,
  ) {
    if (state is! SliderCaptchaLock) {
      context
          .read<SliderCaptchaCubit>()
          .move(detail.localPosition.dx - height / 2);
    }
  }

  void check(
    SliderCaptchaState state,
    BuildContext context,
    DragEndDetails detail,
  ) {
    if (state is! SliderCaptchaLock) {
      context.read<SliderCaptchaCubit>().check(
            state.offsetMove,
          );
    }
  }
}

class _OutlineBorder extends StatelessWidget {
  const _OutlineBorder({required this.height, required this.child, Key? key})
      : super(key: key);

  final double height;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const <BoxShadow>[
            BoxShadow(offset: Offset(0, 0), blurRadius: 2, color: Colors.grey)
          ]),
      child: child,
    );
  }
}
