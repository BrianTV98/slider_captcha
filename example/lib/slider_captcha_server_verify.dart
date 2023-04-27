import 'package:example/provider/slider_captcha_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slider_captcha/slider_captcha.dart';

class SliderCaptchaServerVerify extends StatefulWidget {
  const SliderCaptchaServerVerify({Key? key}) : super(key: key);

  @override
  State<SliderCaptchaServerVerify> createState() =>
      _SliderCaptchaServerVerifyState();
}

class _SliderCaptchaServerVerifyState extends State<SliderCaptchaServerVerify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SliderCaptchaProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const CircularProgressIndicator();
          }
          return SafeArea(
            child: SliderCaptchaClient(
              provider: SliderCaptchaClientProvider(
                  value.captcha?.puzzleImage ?? '',
                  value.captcha?.pieceImage ?? '',
                  value.captcha?.y ?? 0),
              onConfirm: (value) async {
                /// Can you verify captcha at here
                await Future.delayed(const Duration(seconds: 1));
                debugPrint(value.toString());
              },
            ),
          );
        },
      ),
    );
  }
}
