## SLIDER CAPTCHA
Authentication by image


## Install 
* In your `pubspec.yaml` root add:

## Demo
![Showscase gif](https://github.com/BrianTV98/slider_captcha/blob/main/demo/slider_captcha.gif)
## Code Example


Slider Captcha verify with client
```
   SliderCaptcha(
          controller: controller,
          image: Image.asset(
            'assets/image.jpeg',
            fit: BoxFit.fitWidth,
          ),
          colorBar: Colors.blue,
          colorCaptChar: Colors.blue,
          onConfirm: (value) {
            Future.delayed(const Duration(seconds: 1)).then(
              (value) {
                controller.create();
              },
            );
          },
        ),
```

Slider Captcha verify with server:
```
    SliderCaptchaClient(
        provider: SliderCaptchaClientProvider(
            base64Image,
            base64Piece,
            coordinateY,
        ),
        onConfirm: (value) async {
            /// Can you verify captcha at here
            await Future.delayed(const Duration(seconds: 1));
            debugPrint(value.toString());
        },
    ),
```
How to implement server:
  reference: https://github.com/BrianTV98/slider_captcha_server/tree/trunk

Thank you [i5hi](https://github.com/i5hi) recommended and supported 'verify by server' feature.

For details refer to the [discussion](https://github.com/BrianTV98/slider_captcha/discussions/28)

<a href="https://www.buymeacoffee.com/brianTV98" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
