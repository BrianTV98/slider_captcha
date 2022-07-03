import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../pizzule_path.dart';
import 'dart:ui' as ui;

class SliderController {
  late VoidCallback create;
}

class SliderCaptcha extends StatefulWidget {
  const SliderCaptcha(
      {required this.image,
      required this.onConfirm,
      this.title = 'Slide to authenticate',
      this.titleStyle,
      this.captchaSize = 30,
      this.controller,
      Key? key})
      : super(key: key);

  final Image image;

  final void Function(bool value)? onConfirm;

  final String title;

  final TextStyle? titleStyle;

  final double captchaSize;

  final SliderController? controller;

  @override
  State<SliderCaptcha> createState() => _SliderCaptchaState();
}

class _SliderCaptchaState extends State<SliderCaptcha>
    with SingleTickerProviderStateMixin {
  double heightSliderBar = 50;

  double _offsetMove = 0;

  double answerX = 0;

  double answerY = 0;

  late SliderController controller;

  late Animation<double> animation;
  late AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onHorizontalDragStart: (DragStartDetails detail) {
              debugPrint(detail.localPosition.toString());
            },
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: _captcha(context, _offsetMove, answerY),
            ),
          ),
          Container(
            height: heightSliderBar,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 2,
                    color: Colors.grey,
                  )
                ]),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Text(widget.title,
                      style: widget.titleStyle, textAlign: TextAlign.center),
                ),
                Positioned(
                    left: _offsetMove,
                    top: 0,
                    height: 50,
                    width: 50,
                    child: GestureDetector(
                      onHorizontalDragStart: (DragStartDetails detail) {
                        _onDragStart(context, detail);
                      },
                      onHorizontalDragUpdate: (DragUpdateDetails detail) {
                        _onDragUpdate(context, detail);
                      },
                      onHorizontalDragEnd: (DragEndDetails detail) {
                        checkAnswer();
                      },
                      child: Container(
                        height: heightSliderBar,
                        width: heightSliderBar,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            boxShadow: const <BoxShadow>[
                              BoxShadow(color: Colors.grey, blurRadius: 4)
                            ]),
                        child: const Icon(Icons.arrow_forward_rounded),
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  _onDragStart(BuildContext context, DragStartDetails start) {
    RenderBox getBox = context.findRenderObject() as RenderBox;

    var local = getBox.globalToLocal(start.globalPosition);

    setState(() {
      _offsetMove = local.dx - heightSliderBar / 2;
    });
  }

  _onDragUpdate(BuildContext context, DragUpdateDetails update) {
    RenderBox getBox = context.findRenderObject() as RenderBox;
    var local = getBox.globalToLocal(update.globalPosition);

    if (local.dx < 0) {
      _offsetMove = 0;
      setState(() {});
      return;
    }

    if (local.dx > getBox.size.width) {
      _offsetMove = getBox.size.width - heightSliderBar;
      setState(() {});
      return;
    }

    setState(() {
      _offsetMove = local.dx - heightSliderBar / 2;
    });
    debugPrint(_offsetMove.toString());
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      controller = SliderController();
    } else {
      controller = widget.controller!;
    }

    controller.create = reset;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: 1, end: 0).animate(animationController)
      ..addListener(() {
        setState(() {
          _offsetMove = _offsetMove * animation.value;
        });
      })
      ..addStatusListener((status) {

        if (status == AnimationStatus.completed) {
          animationController.reset();
        }
      }
      );
    answerX = -100;
    answerX =-100;
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _createUIInfo();
    });
    super.didChangeDependencies();
  }

  void onUpdate(double d) {
    setState(() {
      _offsetMove = d;
    });
  }

  void _createUIInfo() async {
    double width = context.size!.width;
//
    answerX = widget.captchaSize +
        Random().nextInt((width - 2 * widget.captchaSize).toInt());
//
    answerY = MediaQuery.of(context).padding.top+ Random().nextInt((200 - widget.captchaSize).toInt()).toDouble();
  }

  Widget _captcha(BuildContext context, double x, double y) {
    return TestSliderCaptChar(
      widget.image,
      PathTest(),
      x,
      y,
      answerX,
      answerY,
    );
  }

  void checkAnswer() {
    if (_offsetMove<answerX +10  &&_offsetMove>answerX -10  ) {
      if (widget.onConfirm != null) {
        widget.onConfirm!(true);
      }
    } else {
      if (widget.onConfirm != null) {
        widget.onConfirm!(false);
      }
    }

    // reset();
  }

  void reset() {
    animationController.forward().then((value) {
      _createUIInfo();
    });

  }
}

class TestSliderCaptChar extends SingleChildRenderObjectWidget {
  final Image image;

  final BasePath path;

  final double offsetX;

  final double offsetY;

  final double createX;

  final double createY;

  final double sizeCaptchar;

  const TestSliderCaptChar(this.image, this.path, this.offsetX, this.offsetY,
      this.createX, this.createY,
      {this.sizeCaptchar = 40, Key? key})
      : super(key: key, child: image);

  @override
  RenderObject createRenderObject(BuildContext context) {
    final renderObject = _RenderTestSliderCaptChar(
        path, sizeCaptchar, offsetX, offsetY, createX, createY);
    // renderObject.create(sizeCaptchar);
    updateRenderObject(context, renderObject);
    return renderObject;
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderTestSliderCaptChar renderObject) {
    // renderObject.path = image;

    renderObject.offsetX = offsetX;
    renderObject.offsetY = offsetY;
    renderObject.createX = createX;
    renderObject.createY = createY;
  }
}

class _RenderTestSliderCaptChar extends RenderProxyBox {
  final BasePath path;

  final double sizeCaptChar;

  double offsetX;

  double offsetY;

  double createX;

  double createY;

  _RenderTestSliderCaptChar(
    this.path,
    this.sizeCaptChar,
    this.offsetX,
    this.offsetY,
    this.createX,
    this.createY,
  );

  @override
  void paint(PaintingContext context, Offset offset) {
    debugPrint(createY.toString());

    if (child == null) return;

    context.paintChild(child!, offset);
    if (!(child!.size.width > 0 && child!.size.height > 0)) {
      return;
    }


    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0;

    context.canvas.drawPath(
      getPiecePathCustom(
          size, createX.toDouble(), createY.toDouble(), sizeCaptChar),
      paint..style = PaintingStyle.fill,
    );

    context.canvas.translate(-createX.toDouble(), 0);

    if(!(createY == 0 && createY == 0)){
      context.canvas.drawPath(
          getPiecePathCustom(size, offsetX + createX.toDouble(),
              createY.toDouble(), sizeCaptChar),
          paint..style =PaintingStyle.stroke);
    }




    layer = context.pushClipPath(
      needsCompositing,
      Offset(offsetX,  offset.dy),
      Offset.zero & size,
      getPiecePathCustom(size, createX.toDouble(), createY.toDouble() -  offset.dy, 40),
      (context, offset) {
        debugPrint('test: ${offset.toString()}');
        context.paintChild(child!, offset);
      },
      oldLayer: layer as ClipPathLayer?,
    );
    context.canvas.translate(createX.toDouble(), 0);
  }

}

abstract class BasePath {
  Path drawPath(Path path);
}

class PathTest extends BasePath {
  var sizePart = 50.0;

  final double bumpSize = 50 / 4;

  @override
  Path drawPath(Path path) {
    // Path path = Path();
    // top bump
    path.lineTo(sizePart / 3, 0);

    path.cubicTo(sizePart / 6, bumpSize, sizePart / 6 * 5, bumpSize,
        sizePart / 3 * 2, 0);

    path.lineTo(sizePart.toDouble(), 0);

    // right bump
    path.lineTo(sizePart.toDouble(), sizePart / 3);

    path.cubicTo(sizePart - bumpSize, sizePart / 6, sizePart - bumpSize,
        sizePart / 6 * 5, sizePart.toDouble(), sizePart / 3 * 2);

    path.lineTo(sizePart, sizePart);

    path.lineTo(sizePart / 3 * 2, sizePart);

    path.lineTo(0, sizePart);

    //   // left bump
    path.lineTo(0, sizePart / 3 * 2);

    path.cubicTo(
        bumpSize, sizePart / 6 * 5, bumpSize, sizePart / 6, 0, sizePart / 3);

    return path;
  }
}
