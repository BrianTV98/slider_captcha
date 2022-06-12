
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
    return Scaffold(
        // floatingActionButton: IconButton(
        //   icon: const Icon(Icons.add_shopping_cart),
        //   onPressed: () => showCaptcha(context),
        // ),
        body:  Center(
          child: SliderCaptcha(
            controller: controller,
            image: Image.asset(
              'assets/image.jpeg',
              fit: BoxFit.fitWidth,
            ),
            onConfirm: (value){
              debugPrint(value.toString());
              Future.delayed(const Duration(seconds: 1)).then((value) {
                 controller.create();
              });
            }
          ),
        ));

  }

  void showMyDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Authentication successful!'),
              ],
            ),
          );
        });
  }

  void showCaptcha(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: 280,
              width: 280,
              padding: const EdgeInsets.all(8.0),
              child: SliderCaptcha(
                image: Image.asset(
                  'assets/image.jpeg',
                  fit: BoxFit.fitWidth,
                ), onConfirm: (bool value) {  },
                // onConfirm: () => showMyDialog(context),
              ),
            ),
          );
        });
  }
}
