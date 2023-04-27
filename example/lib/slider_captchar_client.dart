import 'package:example/provider/slider_captchar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slider_captcha/slider_capchar.dart';

class SliderCaptchaClientDemo extends StatefulWidget {
  const SliderCaptchaClientDemo({Key? key}) : super(key: key);

  @override
  State<SliderCaptchaClientDemo> createState() =>
      _SliderCaptchaClientDemoState();
}

class _SliderCaptchaClientDemoState extends State<SliderCaptchaClientDemo> {
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
