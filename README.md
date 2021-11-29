## SLIDER CAPTCHA
Authentication by image


## Install 
* In your `pubspec.yaml` root add:

```yaml
dependencies:
  slider_captcha: ^0.0.2
  flutter_bloc: ^7.3.3
  equatable: ^2.0.3
```


## Demo
![Showscase gif](https://github.com/BrianTV98/slider_captcha/blob/main/demo/slider_captcha.gif)
## Code Example

```
   SliderCaptcha(
         image: Image.asset(
            'assets/image.jpeg',
             fit: BoxFit.fitWidth,
         ),
         onSuccess: () => showMyDialog(context),
   ),

```

## Demo
![Showscase gif](https://github.com/BrianTV98/slider_captcha/blob/main/demo/slider_captcha_extention.gif)
```
   SliderCaptchaExtension(
         image: Image.asset(
            'assets/image.jpeg',
             fit: BoxFit.fitWidth,
         ),
         onSuccess: () => showMyDialog(context),
   ),

```

