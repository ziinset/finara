import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // ── Form controllers ──
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  // ── Reactive state ──
  final isPasswordHidden = true.obs;

  // ── Animation ──
  late AnimationController animationController;

  // Staggered fade animations
  late Animation<double> illustrationFade;
  late Animation<double> cardFade;
  late Animation<double> formFade;
  late Animation<double> buttonFade;
  late Animation<double> footerFade;

  // Staggered slide animations
  late Animation<Offset> illustrationSlide;
  late Animation<Offset> cardSlide;
  late Animation<Offset> formSlide;
  late Animation<Offset> buttonSlide;
  late Animation<Offset> footerSlide;

  @override
  void onInit() {
    super.onInit();

    usernameController = TextEditingController(text: 'Kharisma Aretha');
    passwordController = TextEditingController(text: '12345678');

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Staggered fade animations
    illustrationFade = _createFade(0.0, 0.35);
    cardFade = _createFade(0.15, 0.50);
    formFade = _createFade(0.30, 0.65);
    buttonFade = _createFade(0.45, 0.80);
    footerFade = _createFade(0.55, 0.90);

    // Staggered slide animations
    illustrationSlide = _createSlide(0.0, 0.35);
    cardSlide = _createSlide(0.15, 0.50, fromBottom: true);
    formSlide = _createSlide(0.30, 0.65, fromBottom: true);
    buttonSlide = _createSlide(0.45, 0.80, fromBottom: true);
    footerSlide = _createSlide(0.55, 0.90, fromBottom: true);
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
    double begin,
    double end, {
    bool fromBottom = false,
  }) {
    return Tween<Offset>(
      begin: Offset(0, fromBottom ? 0.12 : -0.05),
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
    usernameController.dispose();
    passwordController.dispose();
    animationController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void onLogin() {
    // TODO: Implement login logic
    Get.toNamed('/home');
  }

  void onForgotPassword() {
    // TODO: Implement forgot password navigation
  }

  void onRegister() {
    Get.toNamed('/register');
  }
}
