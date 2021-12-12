import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slider_captcha/logic/standard/slider_captcha_cubit.dart';
import 'package:slider_captcha/presentation/widgets/slider_bar.dart';
import 'package:slider_captcha/presentation/widgets/slider_panel.dart';

class SliderCaptcha extends StatelessWidget {
  const SliderCaptcha({required this.image, required this.onSuccess,
    this.captchaSize = 30, Key? key})
      : super(key: key);

  final Image image;

  final void Function() onSuccess;

  final double captchaSize ;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (_) =>
            SliderCaptchaCubit(
                context: context,
                height: 200,
                sizeCaptcha: captchaSize,
                onSuccess: onSuccess),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            SizedBox(
                height: 200,
                child: SliderPanel(
                    sizeCaptcha: captchaSize,
                    image: image)
            ),

            const SliderBar(title: 'Trượt để xác thực'),
          ],
        ),
      ),
    );
  }
}
