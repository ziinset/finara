import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // ── Form Controllers ──
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // ── Observable State ──
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  // ── Focus Nodes ──
  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  // ── Animations ──
  late AnimationController animationController;

  // Staggered fade animations
  late Animation<double> heroFade;
  late Animation<double> titleFade;
  late Animation<double> nameFieldFade;
  late Animation<double> emailFieldFade;
  late Animation<double> passwordFieldFade;
  late Animation<double> buttonFade;
  late Animation<double> footerFade;

  // Staggered slide animations
  late Animation<Offset> heroSlide;
  late Animation<Offset> titleSlide;
  late Animation<Offset> nameFieldSlide;
  late Animation<Offset> emailFieldSlide;
  late Animation<Offset> passwordFieldSlide;
  late Animation<Offset> buttonSlide;
  late Animation<Offset> footerSlide;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Staggered fades
    heroFade = _createFade(0.0, 0.35);
    titleFade = _createFade(0.15, 0.45);
    nameFieldFade = _createFade(0.25, 0.55);
    emailFieldFade = _createFade(0.30, 0.60);
    passwordFieldFade = _createFade(0.35, 0.65);
    buttonFade = _createFade(0.45, 0.75);
    footerFade = _createFade(0.55, 0.85);

    // Staggered slides
    heroSlide = _createSlide(0.0, 0.35);
    titleSlide = _createSlide(0.15, 0.45);
    nameFieldSlide = _createSlide(0.25, 0.55);
    emailFieldSlide = _createSlide(0.30, 0.60);
    passwordFieldSlide = _createSlide(0.35, 0.65);
    buttonSlide = _createSlide(0.45, 0.75);
    footerSlide = _createSlide(0.55, 0.85);
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    animationController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void onRegister() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Oops!',
        'Semua field harus diisi',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFBA1A1A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Email Tidak Valid',
        'Masukkan alamat email yang benar',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFBA1A1A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    // TODO: Implement actual registration logic
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.offAllNamed('/home');
    });
  }

  void onLoginTap() {
    Get.back();
  }
}
