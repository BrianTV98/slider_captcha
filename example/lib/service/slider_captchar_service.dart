import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/captchar_model.dart';

class SliderCaptchaService {
  Future<CaptchaModel?> getCaptcha() async {
    const url = 'http://10.0.2.2:18080/puzzle';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      var result = CaptchaModel.fromJson(json);
      return result;
    }
    return null;
  }
}
