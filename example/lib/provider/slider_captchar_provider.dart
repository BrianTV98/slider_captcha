
import 'package:example/service/slider_captchar_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:slider_captcha/slider_capchar.dart';

class SliderCaptcharProvider extends ChangeNotifier {
  final _service = SliderCaptcharService();
  late CaptchaModel? captcha;


  bool isLoading = false;


  SliderCaptcharProvider(){
    getCaptchar();
  }

  Future<void> getCaptchar() async {
    isLoading= true;
    notifyListeners();
    captcha = await _service.getCaptchar();
    isLoading = false;
    notifyListeners();
  }
}
