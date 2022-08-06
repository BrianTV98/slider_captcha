import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../pizzule_path.dart';

class SliderController {
  late VoidCallback create;
}

class SliderCaptcha extends StatefulWidget {
  const SliderCaptcha({
    required this.image,
    required this.onConfirm,
    this.title = 'Slide to authenticate',
    this.titleStyle,
    this.captchaSize = 30,
    this.colorBar = Colors.red,
    this.colorCaptChar = Colors.blue,
    this.controller,
    Key? key,
  }) : super(key: key);

  final Image image;

  final void Function(bool value)? onConfirm;

  final String title;

  final TextStyle? titleStyle;

  final Color colorBar;

  final Color colorCaptChar;

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
            onHorizontalDragStart: (DragStartDetails detail) {},
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
              child: TestSliderCaptChar(
                widget.image,
                _offsetMove,
                answerY,
                answerX,
                answerY,
                colorCaptChar: widget.colorCaptChar,
              ),
            ),
          ),
          Container(
            height: heightSliderBar,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: widget.colorBar,
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 2,
                  color: Colors.grey,
                )
              ],
            ),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Text(
                    widget.title,
                    style: widget.titleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Positioned(
                  left: _offsetMove,
                  top: 0,
                  height: 50,
                  width: 50,
                  child: GestureDetector(
                    onHorizontalDragStart: (detail) =>
                        _onDragStart(context, detail),
                    onHorizontalDragUpdate: (DragUpdateDetails detail) {
                      _onDragUpdate(context, detail);
                    },
                    onHorizontalDragEnd: (DragEndDetails detail) {
                      debugPrint('endDrag');
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
                        ],
                      ),
                      child: const Icon(Icons.arrow_forward_rounded),
                    ),
                  ),
                ),
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
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

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
      });
    answerX = -100;
    answerX = -100;
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
    /// Kích thước ngang của khung hình
    double width = context.size!.width;
    answerX = widget.captchaSize +
        Random().nextInt((width - 4 * widget.captchaSize).toInt());
//
    answerY = MediaQuery.of(context).padding.top +
        Random().nextInt((200 - widget.captchaSize).toInt()).toDouble();
  }

  void checkAnswer() {
    if (_offsetMove < answerX + 5 && _offsetMove > answerX - 5) {
      widget.onConfirm?.call(true);
    } else {
      widget.onConfirm?.call(false);
    }

  }

  void reset() {
    animationController.forward().then((value) {
      _createUIInfo();
    });
  }
}

class TestSliderCaptChar extends SingleChildRenderObjectWidget {
  ///Hình ảnh góc
  final Image image;

  /// Vị trí dx slider captChar
  final double offsetX;

  /// Vị trí dy slider captChar
  final double offsetY;

  /// Vị trí dx  của phần bị khuyết
  final double createX;

  /// Vị trí dy của phần bi khuyết
  final double createY;

  /// Màu sắt của captchar
  final Color colorCaptChar;

  /// Kích thước của captchar
  final double sizeCaptChar;

  const TestSliderCaptChar(
    this.image,
    this.offsetX,
    this.offsetY,
    this.createX,
    this.createY, {
    this.sizeCaptChar = 40,
    this.colorCaptChar = Colors.blue,
    Key? key,
  }) : super(key: key, child: image);

  @override
  RenderObject createRenderObject(BuildContext context) {
    final renderObject = _RenderTestSliderCaptChar(
        sizeCaptChar, offsetX, offsetY, createX, createY, colorCaptChar);
    updateRenderObject(context, renderObject);
    return renderObject;
  }

  @override
  void updateRenderObject(context, _RenderTestSliderCaptChar renderObject) {
    renderObject.offsetX = offsetX;
    renderObject.offsetY = offsetY;
    renderObject.createX = createX;
    renderObject.createY = createY;
    renderObject.colorCaptChar = colorCaptChar;
  }
}

class _RenderTestSliderCaptChar extends RenderProxyBox {
  final double sizeCaptChar;

  final double strokeWidth = 3;

  double offsetX;

  double offsetY;

  double createX;

  double createY;

  Color colorCaptChar;

  _RenderTestSliderCaptChar(
    this.sizeCaptChar,
    this.offsetX,
    this.offsetY,
    this.createX,
    this.createY,
    this.colorCaptChar,
  );

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;

    /// Vẽ hình background.
    context.paintChild(child!, offset);

    /// Khử trường hợp ảnh bị giật khi sử dụng WidgetsBinding.instance.addPostFrameCallback
    if (!(child!.size.width > 0 && child!.size.height > 0)) {
      return;
    }

    Paint paint = Paint()
      ..color = colorCaptChar
      ..strokeWidth = strokeWidth;

    context.canvas.drawPath(
      getPiecePathCustom(
        size,
        strokeWidth + offset.dx * 2 + createX.toDouble(),
        offset.dy + createY.toDouble(),
        sizeCaptChar,
      ),
      paint..style = PaintingStyle.fill,
    );

    if (!(createY == 0 && createY == 0)) {
      context.canvas.drawPath(
        getPiecePathCustom(
          size,
          strokeWidth + offset.dx + offsetX,
          offset.dy + createY,
          sizeCaptChar,
        ),
        paint..style = PaintingStyle.stroke,
      );
    }

    layer = context.pushClipPath(
      needsCompositing,
      Offset(-createX + offsetX + strokeWidth, offset.dy),
      Offset.zero & size,
      getPiecePathCustom(
        size,
        createX + offset.dx,
        createY.toDouble(),
        sizeCaptChar,
      ),
      (context, offset) {
        context.paintChild(child!, offset);
      },
      oldLayer: layer as ClipPathLayer?,
    );
  }
}

// abstract class BasePath {
//   Path drawPath(Path path);
// }
//
// class PathTest extends BasePath {
//   var sizePart = 50.0;
//
//   final double bumpSize = 50 / 4;
//
//   @override
//   Path drawPath(Path path) {
//     // Path path = Path();
//     // top bump
//     path.lineTo(sizePart / 3, 0);
//
//     path.cubicTo(sizePart / 6, bumpSize, sizePart / 6 * 5, bumpSize,
//         sizePart / 3 * 2, 0);
//
//     path.lineTo(sizePart.toDouble(), 0);
//
//     // right bump
//     path.lineTo(sizePart.toDouble(), sizePart / 3);
//
//     path.cubicTo(sizePart - bumpSize, sizePart / 6, sizePart - bumpSize,
//         sizePart / 6 * 5, sizePart.toDouble(), sizePart / 3 * 2);
//
//     path.lineTo(sizePart, sizePart);
//
//     path.lineTo(sizePart / 3 * 2, sizePart);
//
//     path.lineTo(0, sizePart);
//
//     //   // left bump
//     path.lineTo(0, sizePart / 3 * 2);
//
//     path.cubicTo(
//         bumpSize, sizePart / 6 * 5, bumpSize, sizePart / 6, 0, sizePart / 3);
//
//     return path;
//   }
// }
