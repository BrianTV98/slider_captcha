import 'package:flutter/material.dart';
import 'package:slider_captcha/slider_capchar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SliderController controller = SliderController();

  @override
  Widget build(BuildContext context) {

    debugPrint(MediaQuery.of(context).devicePixelRatio.toString());
    return Scaffold(
      body: SafeArea(
        child: SliderCaptcha(
          controller: controller,
          image: Image.asset(
            'assets/image.jpeg',
            fit: BoxFit.fitWidth,
          ),
          onConfirm: (value) {
            Future.delayed(const Duration(seconds: 3)).then(
              (value) {
                controller.create();
              },
            );
          },
        ),
      ),
    );
  }
}
