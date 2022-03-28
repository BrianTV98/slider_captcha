// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:slider_captcha/logic/slider_captcha_cubit.dart';
//
// class SliderBar extends StatelessWidget {
//   const SliderBar(
//       {required this.title, this.titleStyle, this.height = 50, Key? key})
//       : super(key: key);
//
//   final String title;
//
//   final TextStyle? titleStyle;
//
//   final double height;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height,
//       width: double.infinity,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.white,
//           boxShadow: const <BoxShadow>[
//             BoxShadow(offset: Offset(0, 0), blurRadius: 2, color: Colors.grey)
//           ]),
//       child: Stack(
//         children: <Widget>[
//           Center(
//             child: Text(title, style: titleStyle, textAlign: TextAlign.center),
//           ),
//           BlocBuilder<SliderCaptchaCubit, SliderCaptchaState>(
//             builder: (context, state) {
//               return Positioned(
//                   left: state.offsetMove,
//                   top: 0,
//                   height: 50,
//                   width: 50,
//                   child: GestureDetector(
//                     onHorizontalDragStart: (DragStartDetails detail) {
//                       // widget.onchange(0);
//                     },
//                     onHorizontalDragUpdate: (DragUpdateDetails detail) {
//                       context
//                           .read<SliderCaptchaCubit>()
//                           .move(detail.localPosition.dx - height / 2);
//                     },
//                     onHorizontalDragEnd: (DragEndDetails detail) {
//                       context
//                           .read<SliderCaptchaCubit>()
//                           .check(state.offsetMove);
//                     },
//                     child: Container(
//                       height: height,
//                       width: height,
//                       margin: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           color: Colors.white,
//                           boxShadow: const <BoxShadow>[
//                             BoxShadow(color: Colors.grey, blurRadius: 4)
//                           ]),
//                       child: const Icon(Icons.arrow_forward_rounded),
//                     ),
//                   ));
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
