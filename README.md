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
            debugPrint(value.toString());
            Future.delayed(const Duration(seconds: 1)).then(
              (value) {
                controller.create();
              },
            );
          },
        ),
```

<a href="https://www.buymeacoffee.com/brianTV98" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
