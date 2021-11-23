part of 'slider_captcha_cubit.dart';

@immutable
abstract class SliderCaptchaState extends Equatable {
  const SliderCaptchaState(this.offsetMove);

  final double offsetMove;
}

class SliderCaptchaLoading extends SliderCaptchaState {
  const SliderCaptchaLoading() : super(0);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SliderCaptchaMove extends SliderCaptchaState {
  const SliderCaptchaMove(double offsetX) : super(offsetX);

  @override
  // TODO: implement props
  List<Object?> get props => [offsetMove];
}
