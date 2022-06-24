import 'dart:math';

import 'package:flutter/material.dart';

import '../pizzule_path.dart';

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

class _SliderCaptchaState extends State<SliderCaptcha> {
  double heightSliderBar = 50;

  double _offsetMove = 0;

  double answerX = 0;

  double answerY = 0;

  late SliderController controller;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Stack(
              children: [
                widget.image,
                _captcha(context, answerX, answerY),
                _slice(context, _offsetMove, answerY),
              ],
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
                      offset: Offset(0, 0), blurRadius: 2, color: Colors.grey)
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
  }

  Widget _slice(BuildContext context, x, y) {
    return CustomPaint(
      foregroundPainter: PuzzlePiecePainter(
          widget.captchaSize + 6, widget.captchaSize + 6, x + 10, y,
          paintingStyle: PaintingStyle.fill),
    );
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
    answerY = Random().nextInt((200 - widget.captchaSize).toInt()).toDouble();
  }

  Widget _captcha(BuildContext context, double x, double y) {
    return ClipPath(
      child: CustomPaint(
          foregroundPainter: PuzzlePiecePainter(
              widget.captchaSize + 6, widget.captchaSize + 6, x, y),
          child: widget.image),
      clipper: PuzzlePieceClipper(
          widget.captchaSize + 6, widget.captchaSize + 6, x, y),
    );
  }

  void checkAnswer() {
    if (answerX - 5 < (_offsetMove + 10) && (_offsetMove + 10) < answerX + 5) {
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
    _createUIInfo();
    _offsetMove = 0;
    setState(() {});
  }
}
