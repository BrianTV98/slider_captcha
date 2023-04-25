## SLIDER CAPTCHA
Authentication by image


## Install 
* In your `pubspec.yaml` root add:

## Demo
![Showscase gif](https://github.com/BrianTV98/slider_captcha/blob/main/demo/slider_captcha.gif)
## Code Example

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

From version 1.0.0: slider captchar support server verify method.
Thank for I5hi was support for this method.
Detail at ![discusstion])(https://github.com/BrianTV98/slider_captcha/discussions/28)
Server side protocol: ![githud](https://github.com/i5hi/slider_captcha_server)
<a href="https://www.buymeacoffee.com/brianTV98" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
