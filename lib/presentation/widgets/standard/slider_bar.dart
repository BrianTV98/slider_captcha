import 'package:flutter/material.dart';
import 'package:slider_captcha/logic/slider_controller.dart';

class SliderBar extends StatelessWidget {
  const SliderBar(
      {required this.sliderController,
      required this.title,
      this.height = 50,
      Key? key})
      : super(key: key);

  final String title;

  final double height;

  final SliderController sliderController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>sliderController.sink.add(Point(100, 100)),
      child: _OutlineBorder(
        height: height,
        child: Stack(
          children: <Widget>[_title(), _button()],
        ),
      ),
    );
  }

  Widget _button() {
    return StreamBuilder<Point>(
        stream: sliderController.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              debugPrint('none');
              return const SizedBox();
            case ConnectionState.waiting:
              debugPrint('waiting');
              return const SizedBox();
            case ConnectionState.active:
              debugPrint('active');
              return const SizedBox();
            case ConnectionState.done:
              debugPrint('done');
              return Positioned(
                  left: snapshot.data?.x ?? 500,
                  top: 0,
                  height: 50,
                  width: 50,
                  child: GestureDetector(
                    onHorizontalDragStart: (DragStartDetails detail) {
                      // widget.onchange(0);
                    },
                    onHorizontalDragUpdate: (DragUpdateDetails detail) {
                      Point point = Point(
                          detail.localPosition.dx, detail.localPosition.dy);
                      sliderController.sink.add(point);
                    },
                    onHorizontalDragEnd: (DragEndDetails detail) {
                      // check(state, context, detail);
                    },
                    child: Container(
                      height: height,
                      width: height,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          boxShadow: const <BoxShadow>[
                            BoxShadow(color: Colors.grey, blurRadius: 4)
                          ]),
                      child: const Icon(Icons.arrow_forward_rounded),
                    ),
                  ));
          }
        });
  }

  Widget _title() {
    return Center(
      child: Text(title, textAlign: TextAlign.center),
    );
  }
  
}

class _OutlineBorder extends StatelessWidget {
  const _OutlineBorder({required this.height, required this.child, Key? key})
      : super(key: key);

  final double height;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const <BoxShadow>[
            BoxShadow(offset: Offset(0, 0), blurRadius: 2, color: Colors.grey)
          ]),
      child: child,
    );
  }
}
