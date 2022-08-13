import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../pizzule_path.dart';

class SliderController {
  late Offset? Function() create;
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

  final Future<void> Function(bool value)? onConfirm;

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

  /// Khi [confirm] đang thực thiện thì lock =true -> Không cho controller trược
  /// nữa
  bool isLock = false;

  late SliderController controller;
  late final SliderController _controller = SliderController();

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
          TestSliderCaptChar(
            widget.image,
            _offsetMove,
            answerY,
            colorCaptChar: widget.colorCaptChar,
            sliderController: _controller,
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
                    onHorizontalDragStart: (detail) => _onDragStart(context, detail),
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

  void _onDragStart(BuildContext context, DragStartDetails start) {
    if (isLock) return;
    debugPrint(isLock.toString());
    RenderBox getBox = context.findRenderObject() as RenderBox;

    var local = getBox.globalToLocal(start.globalPosition);

    setState(() {
      _offsetMove = local.dx - heightSliderBar / 2;
    });
  }

  _onDragUpdate(BuildContext context, DragUpdateDetails update) {
    if (isLock) return;
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

    animationController.addListener(() {
      debugPrint(animationController.status.toString());
    });
    answerX = -100;
    answerX = -100;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void onUpdate(double d) {
    setState(() {
      _offsetMove = d;
    });
  }

  Future<void> checkAnswer() async {
    if(isLock) return;
    isLock = true;
    if (_offsetMove < answerX + 5 && _offsetMove > answerX - 5) {
      await widget.onConfirm?.call(true);
    } else {
      await widget.onConfirm?.call(false);
    }
    isLock = false;
  }

  Offset? reset() {
    animationController.forward().then((value) {
      Offset? offset = _controller.create.call();
      answerX = offset?.dx ?? 0;
      answerY = offset?.dy ?? 0;
    });
    return null;
  }
}

typedef SliderCreate = Offset? Function();

class TestSliderCaptChar extends SingleChildRenderObjectWidget {
  ///Hình ảnh góc
  final Image image;

  /// Vị trí dx slider captChar
  final double offsetX;

  /// Vị trí dy slider captChar
  final double offsetY;

  /// Màu sắt của captchar
  final Color colorCaptChar;

  /// Kích thước của captchar
  final double sizeCaptChar;

  final SliderController sliderController;

  const TestSliderCaptChar(
    this.image,
    this.offsetX,
    this.offsetY, {
    this.sizeCaptChar = 40,
    this.colorCaptChar = Colors.blue,
    required this.sliderController,
    Key? key,
  }) : super(key: key, child: image);

  @override
  RenderObject createRenderObject(BuildContext context) {
    final renderObject = _RenderTestSliderCaptChar();
    renderObject.offsetX = offsetX;
    renderObject.offsetY = offsetY;
    renderObject.colorCaptChar = colorCaptChar;
    renderObject.sizeCaptChar = sizeCaptChar;
    renderObject.colorCaptChar = colorCaptChar;
    sliderController.create = renderObject.create;
    return renderObject;
  }

  // //
  @override
  void updateRenderObject(context, _RenderTestSliderCaptChar renderObject) {
    renderObject.offsetX = offsetX;
    renderObject.offsetY = offsetY;
    renderObject.colorCaptChar = colorCaptChar;
    renderObject.sizeCaptChar = sizeCaptChar;
    renderObject.colorCaptChar = colorCaptChar;

    super.updateRenderObject(context, renderObject);
  }
}

class _RenderTestSliderCaptChar extends RenderProxyBox {

  /// Kích thước của khối bloc
  double sizeCaptChar = 40;

  /// Kích thước của viền ngoài khối block
  double strokeWidth = 3;

  /// Vị trí đỉnh [dx] của puzzle block
  double offsetX = 0;

  /// Vị trí đỉnh [dy] của puzzle block
  double offsetY = 0;

  /// kết quả: dx
  double createX = 0;
  /// kết quả: dy
  double createY = 0;

  /// màu sắc của khối bloc
  Color colorCaptChar = Colors.black;

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

    if (createX == 0 && createY == 0) return;

    context.canvas.drawPath(
      getPiecePathCustom(
        size,
        strokeWidth + offset.dx + createX.toDouble(),
        offset.dy + createY.toDouble(),
        sizeCaptChar,
      ),
      paint..style = PaintingStyle.fill,
    );

    context.canvas.drawPath(
      getPiecePathCustom(
        size,
        strokeWidth + offset.dx + offsetX,
        offset.dy + createY,
        sizeCaptChar,
      ),
      paint..style = PaintingStyle.stroke,
    );

    layer = context.pushClipPath(
      needsCompositing,

      /// Move về đầu [-create] và trược theo offsetX
      Offset(-createX + offsetX + offset.dx + strokeWidth, offset.dy),
      Offset.zero & size,
      getPiecePathCustom(
        size,
        createX,
        createY.toDouble(),
        sizeCaptChar,
      ),
      (context, offset) {
        context.paintChild(child!, offset);
      },
      oldLayer: layer as ClipPathLayer?,
    );
  }

  @override
  void performLayout() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /// tam fix
      if (createX != 0 && createY != 0) return;
      create();
    });

    super.performLayout();
  }

  /// Hàm khởi tạo kết quả của khối bloc
  Offset? create() {
    if (size == Size.zero) {
      return null;
    }
    createX = sizeCaptChar +
        Random().nextInt((size.width - 2.5 * sizeCaptChar).toInt());

    createY = 0.0 + Random().nextInt((size.height - sizeCaptChar).toInt());

    return Offset(createX, createY);
  }
}
