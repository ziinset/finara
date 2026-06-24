import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/register_controller.dart';

/// Design system colors from DESIGN.md ("Organic Fintech" palette).
class _AppColors {
  static const Color background = Color(0xFFF1F3E9);
  static const Color primary = Color(0xFF3D5C45);
  static const Color inputIcon = Color(0xFF498B59);
}

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _AppColors.background,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    // ── Hero Section (45% height) ──
                    _buildHeroSection(context),

                    // ── Form Container (fills remaining) ──
                    Expanded(child: _buildFormContainer(context)),
                  ],
                ),
              ),

              // ── [DEV-ONLY] Tombol Skip — hapus/comment blok ini setelah selesai development ──
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                right: 16,
                child: GestureDetector(
                  onTap: () => Get.offAllNamed(Routes.HOME),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Skip',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: _AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // ── [DEV-ONLY] Akhir tombol Skip ──
            ],
          ),
        ),
      ),
    );
  }

  /// Hero section — character illustration with a background vector.
  Widget _buildHeroSection(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return SlideTransition(
          position: controller.heroSlide,
          child: FadeTransition(
            opacity: controller.heroFade,
            child: child,
          ),
        );
      },
      child: SizedBox(
        height: screenHeight * 0.40,
        width: double.infinity,
        child: Stack(
          children: [
            // ── Background decorative vector (subtle) ──
            Positioned(
              right: 24,
              top: screenHeight * 0.08,
              child: Opacity(
                opacity: 0.12,
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAR-_oN_beBdczJkOKsdsXnJTIqiChlqsOElPWUDllEjAapbHSAjtarRogvzrtV-a1mhUPT1Ggcq93p-ziZvdW3okO8FWb-5pLiNwVc6CNTO1_W90duWAD5uq3njmOSt7qNG1XPmNLkyrD0NjwOUHDe2YD09MoufXxDsp3LMhgTPS1m_aq5nePopD9duaPHEX9xretrcyFdKOT-4WLUR6BaWS4e80pQjZHQkkN0lrgmKIWtnzzATSD-5uhIENWwdVAFZuTL3ZFgxHAM',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),
            ),

            // ── Character illustration ──
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Transform.translate(
                  offset: const Offset(-16, 0),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuC6I2nuhwuIkPV9bxkXjKrLKoHJvrrZEAk2jG75UNWpmuKEWxNF-IeRPyzQ1Ynz4IJ5_yjH38CfG2TQGBdiBteEIfsogyDCJHsR8O2XE2qPdLU8xqt98UHL-d_cbs5SUUE4WK3E6ouOSnJOclj4dz-_JVwExPwx-N9qloEFeaor7l-50_uhTXyfZCBoJne_8dhENidBndO0Q6j65OqNfVVrCi0R7bnxBBBGh2wVnonHfg9PjwV11xI4OOUkH4eEIrJElAhuPX_uhqPQ',
                    height: screenHeight * 0.34,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => _buildCharacterPlaceholder(),
                    loadingBuilder: (_, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildCharacterPlaceholder();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Form container — green rounded container with input fields.
  Widget _buildFormContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 30,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
          child: Column(
            children: [
              // ── Title & Subtitle ──
              _buildAnimated(
                fade: controller.titleFade,
                slide: controller.titleSlide,
                child: Column(
                  children: [
                    const Text(
                      'Buat Akun Sekarang',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Daftar untuk mulai kelola progres keuanganmu dengan rapi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.white.withValues(alpha: 0.7),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Name Field ──
              _buildAnimated(
                fade: controller.nameFieldFade,
                slide: controller.nameFieldSlide,
                child: _buildInputField(
                  controller: controller.nameController,
                  focusNode: controller.nameFocus,
                  icon: Icons.person_outlined,
                  placeholder: 'Nama Lengkap',
                  keyboardType: TextInputType.name,
                ),
              ),

              const SizedBox(height: 16),

              // ── Email Field ──
              _buildAnimated(
                fade: controller.emailFieldFade,
                slide: controller.emailFieldSlide,
                child: _buildInputField(
                  controller: controller.emailController,
                  focusNode: controller.emailFocus,
                  icon: Icons.mail_outlined,
                  placeholder: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
              ),

              const SizedBox(height: 16),

              // ── Password Field ──
              _buildAnimated(
                fade: controller.passwordFieldFade,
                slide: controller.passwordFieldSlide,
                child: _buildPasswordField(),
              ),

              const SizedBox(height: 24),

              // ── Submit Button ──
              _buildAnimated(
                fade: controller.buttonFade,
                slide: controller.buttonSlide,
                child: _buildSubmitButton(),
              ),

              const SizedBox(height: 32),

              // ── Footer: Login Link ──
              _buildAnimated(
                fade: controller.footerFade,
                slide: controller.footerSlide,
                child: _buildFooter(),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable animated wrapper for staggered entrance.
  Widget _buildAnimated({
    required Animation<double> fade,
    required Animation<Offset> slide,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, childWidget) {
        return SlideTransition(
          position: slide,
          child: FadeTransition(
            opacity: fade,
            child: childWidget,
          ),
        );
      },
      child: child,
    );
  }

  /// Standard text input field — white rounded container with icon.
  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required IconData icon,
    required String placeholder,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(
            icon,
            size: 20,
            color: _AppColors.inputIcon,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: keyboardType,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _AppColors.inputIcon,
              ),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  /// Password input field — with visibility toggle button.
  Widget _buildPasswordField() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(
            Icons.lock_outlined,
            size: 20,
            color: _AppColors.inputIcon,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => TextField(
                controller: controller.passwordController,
                focusNode: controller.passwordFocus,
                obscureText: !controller.isPasswordVisible.value,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _AppColors.inputIcon,
                ),
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade400,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
          ),
          Obx(
            () => GestureDetector(
              onTap: controller.togglePasswordVisibility,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: _AppColors.inputIcon,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Submit button — white with green text, matching the HTML design.
  Widget _buildSubmitButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.onRegister,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF3A6043),
            disabledBackgroundColor: Colors.white.withValues(alpha: 0.7),
            elevation: 4,
            shadowColor: Colors.black.withValues(alpha: 0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _AppColors.primary,
                    ),
                  ),
                )
              : const Text(
                  'Daftar Sekarang',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  /// Footer — "Sudah punya akun? Login" link.
  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Sudah punya akun? ',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: controller.onLoginTap,
          child: const Text(
            'Login',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Placeholder widgets ───

  Widget _buildCharacterPlaceholder() {
    return Container(
      width: 180,
      height: 260,
      decoration: BoxDecoration(
        color: _AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(
        Icons.person_outline_rounded,
        size: 80,
        color: _AppColors.primary.withValues(alpha: 0.25),
      ),
    );
  }
}
