import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slider_captcha/slider_capchar.dart';

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
        fontFamily: GoogleFonts.notoEmoji().fontFamily
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
    return Scaffold(
      appBar: AppBar(),
      body: DefaultTextStyle(
        style: GoogleFonts.notoSans(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: SliderCaptcha(
              controller: controller,
              imageToBarPadding: 100,
              image: Image.network(
                'https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8&w=1000&q=80',
                fit: BoxFit.fitWidth,
              ),
              icon: const Icon(Icons.add),
              colorBar: Colors.blue,
              colorCaptChar: Colors.blue,
              onConfirm: (value) async {
                debugPrint(value.toString());
                return await Future.delayed(const Duration(seconds: 5)).then(
                  (value) {
                    controller.create.call();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
