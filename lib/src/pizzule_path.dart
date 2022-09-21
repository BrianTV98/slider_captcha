import 'package:flutter/material.dart';

class PuzzlePiecePainter extends CustomPainter {
  PuzzlePiecePainter(
    this.width,
    this.height,
    this.offsetX,
    this.offsetY, {
    this.paintingStyle = PaintingStyle.stroke,
  });

  final double width;

  final double height;

  final double offsetX;

  final double offsetY;

  final PaintingStyle paintingStyle;

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = paintingStyle
      ..strokeWidth = 3.0;

    canvas.drawPath(getPiecePathCustom(size, offsetX, offsetY, width), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Path getPiecePathCustom(
    Size size, double offsetX, double offsetY, double sizePart) {
  final double bumpSize = sizePart / 4;

  // offsetX = offsetX -sizePart;

  Path path = Path();

  path.moveTo(offsetX, offsetY);

  // top bump
  path.lineTo(offsetX + sizePart / 3, offsetY);

  path.cubicTo(
    offsetX + sizePart / 6,
    offsetY + bumpSize,
    offsetX + sizePart / 6 * 5,
    offsetY + bumpSize,
    offsetX + sizePart / 3 * 2,
    offsetY,
  );

  path.lineTo(offsetX + sizePart, offsetY);

  // right bump
  path.lineTo(offsetX + sizePart, offsetY + sizePart / 3);

  path.cubicTo(
      offsetX + sizePart + bumpSize,
      offsetY + sizePart / 6,
      offsetX + sizePart + bumpSize,
      offsetY + sizePart / 6 * 5,
      offsetX + sizePart,
      offsetY + sizePart / 3 * 2);

  path.lineTo(offsetX + sizePart, offsetY + sizePart);

  path.lineTo(offsetX + sizePart / 3 * 2, offsetY + sizePart);

  path.lineTo(offsetX, offsetY + sizePart);

  //   // left bump
  path.lineTo(offsetX, offsetY + sizePart / 3 * 2);

  path.cubicTo(
      offsetX + bumpSize,
      offsetY + sizePart / 6 * 5,
      offsetX + bumpSize,
      offsetY + sizePart / 6,
      offsetX,
      offsetY + sizePart / 3);

  path.close();

  return path;
}

// this class is used to clip the image to the puzzle piece path
class PuzzlePieceClipper extends CustomClipper<Path> {
  PuzzlePieceClipper(this.height, this.width, this.x, this.y);

  final double width;
  final double height;

  final double x;

  final double y;

  @override
  Path getClip(Size size) {
    return getPiecePathCustom(size, x, y, width);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
