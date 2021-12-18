import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slider_captcha/logic/extention/slider_captcha_extension_cubit.dart';
import 'package:slider_captcha/presentation/widgets/extention/slider_panel_extention.dart';

class SliderCaptchaExtension extends StatelessWidget {
  const SliderCaptchaExtension(
      {required this.image,
      required this.onSuccess,
      this.captchaSize = 30,
      Key? key})
      : super(key: key);

  final Image image;

  final void Function() onSuccess;

  final double captchaSize;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (_) => SliderCaptchaExtensionCubit(
            context: context,
            height: 200,
            sizeCaptcha: captchaSize,
            onSuccess: onSuccess),
        child: SizedBox(
            height: 200,
            child:
                SliderPanelExtension(sizeCaptcha: captchaSize, image: image)),
      ),
    );
  }
}
