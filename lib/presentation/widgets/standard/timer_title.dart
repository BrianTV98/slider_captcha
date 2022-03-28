// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:slider_captcha/logic/slider_captcha_cubit.dart';
//
// class TimerTitle extends StatelessWidget {
//   const TimerTitle({required this.title, Key? key}) : super(key: key);
//
//   final String title;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SliderCaptchaCubit, SliderCaptchaState>(
//       builder: (context, state) {
//         if (state is SliderCaptchaLock) {
//           return Column(
//             children: [
//               Text(title),
//               Text('${getMinute(state.timer)} : ${getSecond(state.timer)}'),
//             ],
//           );
//         }
//         return const SizedBox();
//       },
//     );
//   }
//
//   String getMinute(int timer) {
//     int _timer = timer ~/ 60;
//     return '${(_timer > 9) ? _timer : "0$_timer"}';
//   }
//
//   String getSecond(int timer) {
//     int minute = timer ~/ 60;
//     int second = timer - minute * 60;
//     return '${second > 9 ? second : "0$second"}';
//   }
// }
