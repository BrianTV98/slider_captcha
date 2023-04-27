import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class CaptchaModel {
  final String? requestID;
  final String? puzzleImage;
  final String? pieceImage;
  final double? y;

  CaptchaModel({this.requestID, this.puzzleImage, this.pieceImage, this.y});

  factory CaptchaModel.fromJson(Map<String, dynamic> json) {
    String? requestID = json['request_id'];
    String? puzzleImage = json['puzzle_image'];
    String? pieceImage = json['piece_image'];
    double y = json['y'];

    Image image = _getImage(puzzleImage);

    return CaptchaModel(
        requestID: requestID,
        puzzleImage: puzzleImage,
        pieceImage: pieceImage,
        y: y);
  }

  static Image _getImage(String? puzzleImage) {
    Uint8List bytes = const Base64Decoder().convert(puzzleImage ?? '');
    return Image.memory(bytes);
  }
}
