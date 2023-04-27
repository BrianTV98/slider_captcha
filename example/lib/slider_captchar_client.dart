import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:example/provider/slider_captchar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slider_captcha/slider_capchar.dart';

class SliderCaptcharClientDemo extends StatefulWidget {
  const SliderCaptcharClientDemo({Key? key}) : super(key: key);

  @override
  State<SliderCaptcharClientDemo> createState() =>
      _SliderCaptcharClientDemoState();
}

class _SliderCaptcharClientDemoState extends State<SliderCaptcharClientDemo> {
  Size sizeImage = Size(0, 0);

  double offset = 0;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SliderCaptcharProvider>(
        key: Key('consummer'),
        builder: (context, value, child) {
          if (value.isLoading) {
            return const CircularProgressIndicator();
          }
          Uint8List bytes =
              const Base64Decoder().convert(value.captcha?.puzzleImage ?? '');
          Uint8List piece =
              const Base64Decoder().convert(value.captcha?.pieceImage ?? '');

          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return SafeArea(
                child: SliderCaptchaClient(
                  provider: SliderCaptchaClientProvider(
                    value.captcha?.puzzleImage ?? '',
                    value.captcha?.pieceImage ?? '',
                    value.captcha?.y??0
                  ),
                ),
              );
            },
            // child: SafeArea(
            //   child: Column(
            //     children: [
            //       Test123(
            //         Image.memory(bytes, key: Key('image'),),
            //         Image.memory(
            //           piece,
            //           scale: 2,
            //         ),
            //         value.captcha?.y ?? 0,
            //         offset,
            //         key:Key('Test123'),
            //       ),
            //       Container(
            //         height: 50,
            //         width: double.infinity,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           boxShadow: const <BoxShadow>[
            //             BoxShadow(
            //               offset: Offset(0, 0),
            //               blurRadius: 2,
            //               color: Colors.grey,
            //             )
            //           ],
            //         ),
            //         child: Stack(
            //           children: <Widget>[
            //             // Centerer(
            //             //   child: Text(
            //             //     widget.title,
            //             //     style: widget.titleStyle,
            //             //     textAlign: TextAlign.center,
            //             //   ),
            //             // ),
            //             Positioned(
            //               left: offset,
            //               top: 0,
            //               height: 50,
            //               width: 50,
            //               child: GestureDetector(
            //                 onHorizontalDragStart: (detail) =>
            //                     _onDragStart(context, detail),
            //                 onHorizontalDragUpdate: (DragUpdateDetails detail) {
            //                   _onDragUpdate(context, detail);
            //                 },
            //                 // onHorizontalDragEnd: (DragEndDetails detail) {
            //                 //   checkAnswer();
            //                 // },
            //                 child: Container(
            //                   height: 50,
            //                   width: 50,
            //                   margin: const EdgeInsets.all(4),
            //                   decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(5),
            //                     color: Colors.white,
            //                     boxShadow: const <BoxShadow>[
            //                       BoxShadow(color: Colors.grey, blurRadius: 4)
            //                     ],
            //                   ),
            //                   child: const Icon(Icons.arrow_forward_rounded),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          );
        },
      ),
    );
  }

  _onDragStart(BuildContext context, DragStartDetails start) {
    // if (isLock) return;
    // RenderBox getBox = context.findRenderObject() as RenderBox;
    //
    // var local = getBox.globalToLocal(start.globalPosition);
    //
    // setState(() {
    //   offset = local.dx - 50 / 2;
    // });
  }

  void _onDragUpdate(BuildContext context, DragUpdateDetails update) {
    RenderBox getBox = context.findRenderObject() as RenderBox;
    var local = getBox.globalToLocal(update.globalPosition);

    if (local.dx < 0) {
      offset = 0;
      setState(() {});
      return;
    }

    if (local.dx > getBox.size.width) {
      offset = getBox.size.width - 50;
      setState(() {});
      return;
    }

    setState(() {
      offset = local.dx - 50 / 2;
    });
  }
}
