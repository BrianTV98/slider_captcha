import 'dart:convert';

import 'package:example/model/result.dart';
import 'package:http/http.dart' as http;

import '../model/captcha_model.dart';

class Solution {
  String? id;
  int? x;

  Solution({this.id, this.x});

  Solution.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    x = json['x'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['x'] = x;
    return data;
  }
}

class SliderCaptchaService {
  Future<CaptchaModel?> getCaptcha() async {
    const url = 'http://localhost:18080/puzzle';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      var result = CaptchaModel.fromJson(json);
      return result;
    }
    return null;
  }

  Future<R<String>> postAnswer(Solution solution) async {
    final url = Uri.https('http://localhost:18080/puzzle/solution');
    final response = await http.post(
      url,
      body: jsonEncode(solution.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final status = response.statusCode;
    final body = response.body;
    // error check if response.contains('error');
    if (status == 200) {
      return R(result: body.toString());
    } else {
      return R(error: body.toString());
    }
  }
}
