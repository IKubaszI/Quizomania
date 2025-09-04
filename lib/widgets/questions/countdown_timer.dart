import 'package:flutter/material.dart';
import 'package:fluuterek/configs/themes/custom_text_styles.dart';

class CountdownTimer extends StatelessWidget {
  const CountdownTimer({Key? key, this.color, required this.time}) : super(key: key);
  final Color? color;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.timer,
          color: color ?? Theme.of(context).primaryColor,
        ), // Icon
        const SizedBox(width: 5,),
        Text(
          time,
          style: countDownTimerTs().copyWith(color:color),
        ), // Text
      ],
    );
  }
}
