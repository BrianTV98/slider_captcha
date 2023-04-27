import 'dart:convert';

import 'package:slider_captcha/slider_capchar.dart';

import 'package:http/http.dart' as http;

class SliderCaptcharService{
  Future<CaptchaModel?> getCaptchar()async{
    const url = 'http://10.0.2.2:18080/puzzle';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      var result = CaptchaModel.fromJson(json);
      return result;
    }
  }
}