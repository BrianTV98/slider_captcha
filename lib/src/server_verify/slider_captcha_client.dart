import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:slider_captcha/slider_captcha.dart';

class SliderCaptchaClient extends StatefulWidget {
  const SliderCaptchaClient(
      {required this.provider,
      required this.onConfirm,
      this.titleSlider,
      this.titleStyle,
      Key? key})
      : super(key: key);

  final SliderCaptchaClientProvider provider;

  final String? titleSlider;

  final TextStyle? titleStyle;

  final Future<void> Function(double value) onConfirm;

  @override
  State<SliderCaptchaClient> createState() => _SliderCaptchaClientState();
}

class _SliderCaptchaClientState extends State<SliderCaptchaClient>
    with SingleTickerProviderStateMixin {
  late String titleSlider;

  late TextStyle titleStyle;

  @override
  void initState() {
    // TODO: implement initState
    titleSlider = widget.titleSlider ?? 'Slider to verify';
    titleStyle = widget.titleStyle ?? TextStyle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.provider.init(context),
      key: Key('FutureBuilder'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _SliderCaptchaComponent(
            widget.provider,
            titleSlider,
            titleStyle,
            widget.onConfirm,
          );
        }
        return SizedBox();
      },
    );
  }
}

class _SliderCaptchaComponent extends StatefulWidget {
  const _SliderCaptchaComponent(
      this.provider, this.title, this.titleStyle, this.onConfirm,
      {Key? key})
      : super(key: key);

  final SliderCaptchaClientProvider provider;

  final String title;

  final TextStyle titleStyle;

  final Future<void> Function(double value) onConfirm;

  @override
  State<_SliderCaptchaComponent> createState() =>
      _SliderCaptchaComponentState();
}

class _SliderCaptchaComponentState extends State<_SliderCaptchaComponent>
    with SingleTickerProviderStateMixin {
  Size sizeImage = Size(0, 0);

  double offset = 0;

  late Animation<double> animation;

  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    animation = Tween<double>(begin: 1, end: 0).animate(animationController)
      ..addListener(() {
        setState(() {
          offset = offset * animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reset();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SliderCaptchaRenderObject(
          widget.provider.puzzleImage!,
          widget.provider.pieceImage!,
          widget.provider.coordinatesY,
          offset,
        ),
        sliderBar(),
      ],
    );
  }

  /// You can customize the sliderBar here
  Widget sliderBar() => Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
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
              left: offset,
              top: 0,
              height: 50,
              width: 50,
              child: GestureDetector(
                onHorizontalDragStart: (detail) =>
                    _onDragStart(context, detail),
                onHorizontalDragUpdate: (DragUpdateDetails update) {
                  _onDragUpdate(context, update, setState);
                },
                onHorizontalDragEnd: (DragEndDetails detail) {
                  checkAnswer();
                },
                child: Container(
                  height: 50,
                  width: 50,
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
      );

  void _onDragUpdate(BuildContext context, DragUpdateDetails update,
      void Function(void Function()) setState) {
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

  _onDragStart(BuildContext context, DragStartDetails start) {
    // if (isLock) return;
    RenderBox getBox = context.findRenderObject() as RenderBox;

    var local = getBox.globalToLocal(start.globalPosition);

    setState(() {
      offset = local.dx - 50 / 2;
    });
  }

  void checkAnswer() async {
    var imageSize = widget.provider.puzzleSize.width / widget.provider.ratio;
    await widget.onConfirm.call(offset / imageSize);
    animationController.forward();
    // if (isLock) return;
    // isLock = true;
    //
    // if (_offsetMove < answerX + 10 && _offsetMove > answerX - 10) {
    //   await widget.onConfirm?.call(true);
    // } else {
    //   await widget.onConfirm?.call(false);
    // }
    // isLock = false;
  }
}

class _SliderCaptchaRenderObject extends MultiChildRenderObjectWidget {
  final Image image;
  final Image piece;
  final double percent;
  final double offsetMove;

  _SliderCaptchaRenderObject(
    this.image,
    this.piece,
    this.percent,
    this.offsetMove, {
    Key? key,
  }) : super(children: [image, piece], key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    var renderObject = _RenderTestSliderCaptChar(percent, offsetMove);
    renderObject.offsetMove = offsetMove;
    return renderObject;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    (renderObject as _RenderTestSliderCaptChar).offsetMove = offsetMove;
  }
}

class SliderCaptchaParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderTestSliderCaptChar extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, SliderCaptchaParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, SliderCaptchaParentData> {
  final double percent;

  double offsetMove = 0;

  _RenderTestSliderCaptChar(this.percent, this.offsetMove);

  @override
  void paint(PaintingContext context, Offset offset) {
    var piece = childAfter(firstChild!);
    if (firstChild == null) return;

    if (piece == null) return;
    context.paintChild(firstChild!, offset);

    context.paintChild(
      piece,
      Offset(offset.dx + offsetMove,
          offset.dy + (firstChild?.size.height ?? 0) * percent),
    );
  }

  @override
  void performLayout() {
    final deflatedConstraints = constraints.deflate(EdgeInsets.zero);

    // var pice = childAfter(firstChild!);
    for (var child = firstChild; child != null; child = childAfter(child)) {
      child.layout(deflatedConstraints, parentUsesSize: true);
    }
    size = Size(firstChild?.size.height ?? 0, firstChild?.size.width ?? 0);
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! SliderCaptchaParentData) {
      child.parentData = SliderCaptchaParentData();
    }
  }
}
