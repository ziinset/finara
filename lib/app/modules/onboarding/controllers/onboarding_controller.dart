import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;

  // Staggered fade animations for each element
  late Animation<double> logoFade;
  late Animation<double> blackCardFade;
  late Animation<double> greenCardFade;
  late Animation<double> plusButtonFade;
  late Animation<double> characterFade;
  late Animation<double> badgeFade;
  late Animation<double> contentFade;
  late Animation<double> buttonFade;

  // Staggered slide animations
  late Animation<Offset> logoSlide;
  late Animation<Offset> blackCardSlide;
  late Animation<Offset> greenCardSlide;
  late Animation<Offset> plusButtonSlide;
  late Animation<Offset> characterSlide;
  late Animation<Offset> badgeSlide;
  late Animation<Offset> contentSlide;
  late Animation<Offset> buttonSlide;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Staggered fade animations — each element appears sequentially
    logoFade = _createFade(0.0, 0.25);
    blackCardFade = _createFade(0.05, 0.30);
    greenCardFade = _createFade(0.10, 0.35);
    plusButtonFade = _createFade(0.20, 0.45);
    characterFade = _createFade(0.15, 0.45);
    badgeFade = _createFade(0.30, 0.55);
    contentFade = _createFade(0.40, 0.70);
    buttonFade = _createFade(0.50, 0.80);

    // Staggered slide animations
    logoSlide = _createSlide(0.0, 0.25, const Offset(0, -0.15));
    blackCardSlide = _createSlide(0.05, 0.30, const Offset(-0.15, 0));
    greenCardSlide = _createSlide(0.10, 0.35, const Offset(0.15, 0));
    plusButtonSlide = _createSlide(0.20, 0.45, const Offset(0, -0.2));
    characterSlide = _createSlide(0.15, 0.45, const Offset(0, 0.12));
    badgeSlide = _createSlide(0.30, 0.55, const Offset(0.1, 0.1));
    contentSlide = _createSlide(0.40, 0.70, const Offset(0, 0.08));
    buttonSlide = _createSlide(0.50, 0.80, const Offset(0, 0.12));
  }

  Animation<double> _createFade(double begin, double end) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(begin, end, curve: Curves.easeOut),
      ),
    );
  }

  Animation<Offset> _createSlide(
      double begin, double end, Offset startOffset) {
    return Tween<Offset>(
      begin: startOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(begin, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void onReady() {
    super.onReady();
    animationController.forward();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void onGetStarted() {
    Get.toNamed('/register');
  }
}
