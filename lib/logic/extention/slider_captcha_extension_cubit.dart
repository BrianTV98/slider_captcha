import 'dart:async';
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slider_captcha/utils/ticker.dart';
part 'slider_captcha_extension_state.dart';

class SliderCaptchaExtensionCubit extends Cubit<SliderCaptchaExtensionState> {
  SliderCaptchaExtensionCubit({
    required this.context,
    required this.onSuccess,
    required this.height,
    this.sizeCaptcha = 50,
    this.lockTime = 10,
    this.deviation = 5,
  }) : super(const SliderCaptchaExtensionLoad()) {
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

  ///when user wright over 5 times, UI will be lock [lockTime] second
  final int lockTime;

  /// allow deviation  is +- [deviation] pixel
  final int deviation;

  ///@Description: position of captcha (local position) follow coordinates X
  double x = 0;

  ///@Description: position of captcha (local position) follow coordinates Y
  double y = 0;

  /// counter wrong captcha
  int wrongNumber = 0;

  /// using to count down timer
  StreamSubscription<int>? _tickerSubscription;

  /// update ui follow dx,dy
  void move(double dx, double dy) {
    emit(SliderCaptchaExtensionMove(dx, dy));
  }

  /// check captcha is right or wrong, if right, It will call [onSuccess] action
  /// else  if wright over 5 times, We will lock UI.
  void check() {
    if (wrongNumber == 4) {
      _lockUI();
      return;
    }

    if (_isRightCaptcha()) {
      onSuccess();
    } else {
      wrongNumber++;
      emit(const SliderCaptchaExtensionMove(0, 0));
    }
  }

  /// create position of captcha.
  void _load(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _createUIInfo();
    });
  }

  void _lockUI() {
    _tickerSubscription = const Ticker().tick(ticks: lockTime).listen((event) {
      if (event == 0) {
        _resetCaptcha();
      } else {
        emit(SliderCaptchaExtensionLock(event));
      }
    });
  }

  /// create position of captcha.
  void _createUIInfo() async {
    double width = context.size!.width;

    /// trick code because  only cut path, couldn't cut size(remove space)
    x = sizeCaptcha + Random().nextInt((width - 2 * sizeCaptcha).toInt());

    y = Random().nextInt((height - sizeCaptcha).toInt()).toDouble();

    emit(const SliderCaptchaExtensionMove(0, 0));
  }

  ///after lock UI, will change captcha and reset [wrongNumber]
  void _resetCaptcha() {
    ///resetWrongNumber
    wrongNumber = 0;
    _createUIInfo();
  }

  bool _isRightCaptcha() {
    return state.offsetX < x + deviation &&
        state.offsetX > x - deviation &&
        state.offsetY < y + deviation &&
        state.offsetY > y - deviation;
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _tickerSubscription?.cancel();
    return super.close();
  }
}
