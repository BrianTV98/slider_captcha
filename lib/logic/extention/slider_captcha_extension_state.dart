part of 'slider_captcha_extension_cubit.dart';

@immutable
abstract class SliderCaptchaExtensionState extends Equatable {
  const SliderCaptchaExtensionState(this.offsetX, this.offsetY);

  /// position of captcha on coordinates X
  final double offsetX;

  /// position of captcha in coordinates Y
  final double offsetY;
}

/// in this state, will create captcha
class SliderCaptchaExtensionLoad extends SliderCaptchaExtensionState {
  const SliderCaptchaExtensionLoad() : super(0, 0);

  @override
  // TODO: implement props
  List<Object?> get props => [offsetX, offsetY];
}

/// in this state, will update UI
class SliderCaptchaExtensionMove extends SliderCaptchaExtensionState {
  const SliderCaptchaExtensionMove(double offsetX, double offsetY)
      : super(offsetX, offsetY);

  @override
  // TODO: implement props
  List<Object?> get props => [offsetX, offsetY];
}

/// in this state, will lockUI
class SliderCaptchaExtensionLock extends SliderCaptchaExtensionState {
  const SliderCaptchaExtensionLock(this.timer) : super(0, 0);

  final int timer;

  @override
  // TODO: implement props
  List<Object?> get props => [timer];
}
