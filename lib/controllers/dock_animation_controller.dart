import 'package:flutter/material.dart';

class DockAnimationController {
  final AnimationController controller;
  late final Animation<double> scaleAnimation;

  DockAnimationController(TickerProvider vsync)
      : controller = AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: vsync,
        ) {
    scaleAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
  }

  void dispose() {
    controller.dispose();
  }

  void forward() => controller.forward();
  void reverse() => controller.reverse();
}
