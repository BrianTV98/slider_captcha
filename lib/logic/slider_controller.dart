import 'dart:async';

/// controller position

class SliderController{
  final StreamController<Point> _controller = StreamController<Point>.broadcast();

  Stream<Point> get stream => _controller.stream;

  Sink<Point> get sink => _controller.sink;

  SliderController(){
    sink.add(Point(0, 0));
  }

}

class Point{
  final double x;
  final double y;

  Point(this.x, this.y);

}