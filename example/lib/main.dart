import 'package:example/provider/slider_captcha_provider.dart';
import 'package:example/slider_captcha_client_verify.dart';
import 'package:example/slider_captcha_server_verify.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slider_captcha/slider_captcha.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SliderCaptchaServerVerify());
        // home: const SliderCaptchaClientVerify(title: 'Slider to verify'));
  }
}
