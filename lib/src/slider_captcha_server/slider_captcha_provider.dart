import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class SliderCaptchaClientProvider {
  late Uint8List puzzleUnit8List;
  late Uint8List pieceUnit8List;
  late Size puzzleSize;
  late Size pieceSize;
   Image? puzzleImage;
   Image? pieceImage;

  late double ratio;

  final String puzzleBase64;
  final String pieceBase64;
  /// Y cordinate
  final double coordinates;



  SliderCaptchaClientProvider(this.puzzleBase64, this.pieceBase64, this.coordinates){
    puzzleUnit8List =  Base64Decoder().convert(puzzleBase64);
    pieceUnit8List  =  Base64Decoder().convert(pieceBase64);

  }

  Future<bool> init(BuildContext context) async {

    puzzleSize = await _getSize(puzzleUnit8List);
    pieceSize = await _getSize(pieceUnit8List);
    ratio =  _getRatio(context);

    puzzleImage = Image.memory(puzzleUnit8List);
    pieceImage = Image.memory(pieceUnit8List, scale: ratio,);
    return true;
  }

  Future<Size> _getSize(Uint8List puzzleUnit8List) async{
    var image = await decodeImageFromList(puzzleUnit8List);
    return Size(image.width.toDouble(), image.height.toDouble());
  }

  double _getRatio(BuildContext context) {
    double sizeScreen = MediaQuery.of(context).size.width;

    return puzzleSize.width/sizeScreen;

  }
}
