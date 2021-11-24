import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:slider_captcha/utils/ticker.dart';
part 'slider_captcha_state.dart';

///
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

  ///@Description: when done right captcha, will performance this action
  final Function() onSuccess;

  ///@Description: height of panel captcha
  final double height;

  ///@Description: size of icon captcha,
  ///the size captcha not allow to exceed 1/4 height;
  final double sizeCaptcha;

  double offsetX = 0;

  double offsetY = 0;

  int wrongNumber = 0;



  /// control time
  StreamSubscription<int>? _tickerSubscription;

  void move(double dx) {
    emit(SliderCaptchaMove(dx));
  }

  void check(double dx) {
    if (dx < offsetX + 5 && dx > offsetX - 5) {
      onSuccess();
    } else {
      if (wrongNumber == 4) {
        lockUI();
        return;
      }
      wrongNumber++;
      emit(const SliderCaptchaMove(0));
    }
  }

  void _load(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _createUIInfo();
    });
  }

  void lockUI() {
    _tickerSubscription = const Ticker().tick(ticks: 10).listen((event) {
      if (event == 0) {
        _resetCaptcha();
      } else {
        emit(SliderCaptchaLock(event));
      }
    });
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _resetCaptcha() {
    ///resetWrongNumber
    wrongNumber = 0;
    _createUIInfo();
  }

  void _createUIInfo() async {
    double width = context.size!.width;

    offsetX = sizeCaptcha + Random().nextInt((width - 2 * sizeCaptcha).toInt());

    offsetY = Random().nextInt((height - sizeCaptcha).toInt()).toDouble();

    emit(const SliderCaptchaMove(0));
  }
}
