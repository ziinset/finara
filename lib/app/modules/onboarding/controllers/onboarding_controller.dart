import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  // Staggered animations for each element
  late Animation<double> logoFade;
  late Animation<double> heroFade;
  late Animation<double> characterFade;
  late Animation<double> badgeFade;
  late Animation<double> contentFade;

  late Animation<Offset> logoSlide;
  late Animation<Offset> heroSlide;
  late Animation<Offset> characterSlide;
  late Animation<Offset> badgeSlide;
  late Animation<Offset> contentSlide;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // Staggered fade animations
    logoFade = _createFade(0.0, 0.3);
    heroFade = _createFade(0.05, 0.35);
    characterFade = _createFade(0.15, 0.50);
    badgeFade = _createFade(0.25, 0.60);
    contentFade = _createFade(0.35, 0.75);

    // Staggered slide animations
    logoSlide = _createSlide(0.0, 0.3);
    heroSlide = _createSlide(0.05, 0.35);
    characterSlide = _createSlide(0.15, 0.50);
    badgeSlide = _createSlide(0.25, 0.60);
    contentSlide = _createSlide(0.35, 0.75);
  }

  Animation<double> _createFade(double begin, double end) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(begin, end, curve: Curves.easeOut),
      ),
    );
  }

  Animation<Offset> _createSlide(double begin, double end) {
    return Tween<Offset>(
      begin: const Offset(0, 0.08),
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
    // Navigate to the next screen (e.g., home or registration)
    Get.offAllNamed('/home');
  }
}
