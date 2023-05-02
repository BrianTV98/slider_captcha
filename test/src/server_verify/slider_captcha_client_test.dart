import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slider_captcha/slider_captcha.dart';

void main() {
  group('Slider Captcha Client', () {
    testWidgets('Test if ListView shows up', (tester) async {
      await tester.pumpWidget(
        SliderCaptchaClient(
          provider: SliderCaptchaClientProvider(
            puzzleBase64: '',
            pieceBase64: '',
            coordinatesY: 0.25,
          ),
          onConfirm: (value) async {},
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
