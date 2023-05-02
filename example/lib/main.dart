import 'package:example/slider_captcha_server_verify.dart';
import 'package:flutter/material.dart';

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
