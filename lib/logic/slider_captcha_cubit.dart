import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'slider_captcha_state.dart';

class SliderCaptchaCubit extends Cubit<SliderCaptchaState> {
  SliderCaptchaCubit({
    required this.context,
    required this.onSuccess,
    required this.height,
    this.sizeCaptcha = 50,
  }) : super(const SliderCaptchaLoading()) {
    _load(context);
  }

  final BuildContext context;

  final Function() onSuccess;

  final double height;

  final double sizeCaptcha;

  double offsetX = 0;

  double offsetY = 0;

  void move(double dx) {
    emit(SliderCaptchaMove(dx));
  }

  void check(double dx) {
    if (dx < offsetX + 5 && dx > offsetX - 5) {
      onSuccess();
    } else {
      emit(const SliderCaptchaMove(0));
    }
  }

  void _load(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      double width = context.size!.width;
      // double height = context.size!.height;
      var renderBox = (context.findRenderObject()) as RenderBox;

      Offset position = renderBox.localToGlobal(Offset.zero);

      /// tranh viec trung lap  vs slider
      var _offsetX =
          sizeCaptcha + Random().nextInt((width - sizeCaptcha).toInt());
      var _offsetY =
          Random().nextInt((height - sizeCaptcha).toInt()).toDouble();

      offsetX = _offsetX;

      offsetY = _offsetY;

      emit(const SliderCaptchaMove(0));
    });
  }
}
