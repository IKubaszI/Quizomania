import 'package:flutter/material.dart';

class AppCircleButton extends StatelessWidget {
  const AppCircleButton({
    Key? key,
    required this.child,
    this.color,
    this.onTap,
    this.width = 60,
  }) : super(key: key);

  final Widget child;
  final Color? color;
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      clipBehavior: Clip.hardEdge,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap, // Dodano obsługę kliknięcia
        child: Container(
          width: width,
          height: width,
          decoration: BoxDecoration(
            color: color ?? Colors.grey.withOpacity(0.1), // Domyślny kolor tła
            shape: BoxShape.circle,
          ),
          child: Center(child: child), // Wyśrodkowanie zawartości
        ),
      ),
    );
  }
}
