import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:slider_captcha/slider_capchar.dart';

class SliderCaptchaClient extends StatefulWidget {
  const SliderCaptchaClient({required this.provider, Key? key})
      : super(key: key);

  final SliderCaptchaClientProvider provider;

  @override
  State<SliderCaptchaClient> createState() => _SliderCaptchaClientState();
}

class _SliderCaptchaClientState extends State<SliderCaptchaClient> {
  Size sizeImage = Size(0, 0);

  double offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.provider.init(context),
        key: Key('FutureBuilder'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return StatefulBuilder(
                builder: (context, void Function(void Function()) setState) {
              return Column(
                children: [
                  SliderCaptchaRenderObject(
                    widget.provider.puzzleImage!,
                    widget.provider.pieceImage!,
                    widget.provider.coordinates,
                    offset,
                  ),
                  Container(
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
                        // Centerer(
                        //   child: Text(
                        //     widget.title,
                        //     style: widget.titleStyle,
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ),
                        Positioned(
                          left: offset,
                          top: 0,
                          height: 50,
                          width: 50,
                          child: GestureDetector(
                            onHorizontalDragStart: (detail) =>
                                _onDragStart(context, detail),
                            onHorizontalDragUpdate: (DragUpdateDetails update) {
                              RenderBox getBox =
                                  context.findRenderObject() as RenderBox;
                              var local =
                                  getBox.globalToLocal(update.globalPosition);

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
                            },
                            // onHorizontalDragEnd: (DragEndDetails detail) {
                            //   checkAnswer();
                            // },
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
                  )
                ],
              );
            });
          }
          return SizedBox();
        });
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

class SliderCaptchaRenderObject extends MultiChildRenderObjectWidget {
  final Image image;
  final Image piece;
  final double percent;
  final double offsetMove;

  SliderCaptchaRenderObject(
    this.image,
    this.piece,
    this.percent,
    this.offsetMove, {
    Key? key,
  }) : super(children: [image, piece], key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderTestSliderCaptChar(percent, offsetMove);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    debugPrint(offsetMove.toString());
    (renderObject as _RenderTestSliderCaptChar).offsetMove =
        offsetMove * MediaQuery.of(context).devicePixelRatio;
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
    context.paintChild(firstChild!, Offset(0, 0));
    debugPrint(offset.toString());
    context.paintChild(
      piece,
      Offset(offset.dx + offsetMove, (firstChild?.size.height ?? 0)) * percent,
    );
  }

  @override
  void performLayout() {
    final deflatedConstraints = constraints.deflate(EdgeInsets.zero);

    var pice = childAfter(firstChild!);
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
