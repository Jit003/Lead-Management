import 'package:get/get.dart';
import 'package:flutter/animation.dart';

class PunchAnimationController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void onInit() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    super.onInit();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
