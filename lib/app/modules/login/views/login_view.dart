import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

/// Design system colors extracted from the HTML reference.
class _LoginColors {
  static const Color background = Color(0xFFF1F2E9);
  static const Color cardGreen = Color(0xFF3B5B41);
  static const Color inputText = Color(0xFF7FBC8D);
  static const Color iconGreen = Color(0xFF498B59);
}

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _LoginColors.background,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // ── Top Section: Illustration ──
              Expanded(child: _buildIllustrationSection(context)),

              // ── Bottom Section: Green card with form ──
              _buildFormCard(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Top section — character illustration with the Finara logo badge.
  Widget _buildIllustrationSection(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return SlideTransition(
          position: controller.illustrationSlide,
          child: FadeTransition(
            opacity: controller.illustrationFade,
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16,
        ),
        child: Stack(
          children: [
            // ── Character image ──
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDeNOm8WKS0eK_rAhc4954hd1zUPwK5vSn5W69cZFISQ1iJkVYa02Aj1GVCAL8CNIsggR25Av5IdW2PDDbX64Nezt6gT1e7bq-jtRvtMV2PRnPDG530rohlWhhLaWTZ2Ld9yaT3KM0acEHSqtzQdjzgbujgE0AgZ3z-Nh_rcxIQ1jUCpY967_0dPGelDI6wWPZui0VFEczkmjo9z7DfIPV9vBJX1T13vywe86cIvUZx66_OpLvN3piiMjN74GaRpmiDv2entJH0CSc',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildCharacterPlaceholder();
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildCharacterPlaceholder();
                    },
                  ),
                ),
              ),
            ),

            // ── Finara logo badge (top-right) ──
            Positioned(
              top: 16,
              right: 24,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _LoginColors.cardGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'F',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: _LoginColors.cardGreen,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom section — green card with login form.
  Widget _buildFormCard(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return SlideTransition(
          position: controller.cardSlide,
          child: FadeTransition(
            opacity: controller.cardFade,
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: _LoginColors.cardGreen,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(40),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            28,
            36,
            28,
            MediaQuery.of(context).padding.bottom + 28,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header titles ──
              _buildHeaderTitles(),

              const SizedBox(height: 28),

              // ── Form fields ──
              _buildFormFields(),

              const SizedBox(height: 8),

              // ── Forgot password link ──
              _buildForgotPassword(),

              const SizedBox(height: 20),

              // ── Submit button ──
              _buildSubmitButton(),

              const SizedBox(height: 28),

              // ── Footer link ──
              _buildFooterLink(),
            ],
          ),
        ),
      ),
    );
  }

  /// "Selamat Datang Kembali" heading + subtitle.
  Widget _buildHeaderTitles() {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller.cardFade,
          child: child,
        );
      },
      child: Column(
        children: [
          Text(
            'Selamat Datang Kembali',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 26,
              fontWeight: FontWeight.w600,
              height: 1.2,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Masuk untuk melihat progres keuanganmu',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }

  /// Username and password input fields.
  Widget _buildFormFields() {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return SlideTransition(
          position: controller.formSlide,
          child: FadeTransition(
            opacity: controller.formFade,
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          // ── Username input ──
          _buildInputField(
            controller: controller.usernameController,
            icon: Icons.person,
            obscureText: false,
          ),

          const SizedBox(height: 16),

          // ── Password input ──
          Obx(
            () => _buildInputField(
              controller: controller.passwordController,
              icon: Icons.lock,
              obscureText: controller.isPasswordHidden.value,
              isPassword: true,
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable text field widget with icon prefix.
  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required bool obscureText,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        readOnly: true,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: _LoginColors.inputText,
          letterSpacing: obscureText ? 4.0 : 0.0,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Icon(
              icon,
              color: _LoginColors.iconGreen,
              size: 22,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: this.controller.togglePasswordVisibility,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Obx(
                      () => Icon(
                        this.controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: _LoginColors.iconGreen,
                        size: 22,
                      ),
                    ),
                  ),
                )
              : null,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
        ),
      ),
    );
  }

  /// "Lupa sandi?" link.
  Widget _buildForgotPassword() {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller.formFade,
          child: child,
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: controller.onForgotPassword,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Lupa sandi?',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// White "Daftar Sekarang" button.
  Widget _buildSubmitButton() {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return SlideTransition(
          position: controller.buttonSlide,
          child: FadeTransition(
            opacity: controller.buttonFade,
            child: child,
          ),
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: controller.onLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: _LoginColors.cardGreen,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            'Daftar Sekarang',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _LoginColors.cardGreen,
            ),
          ),
        ),
      ),
    );
  }

  /// "Sudah punya akun? Daftar" footer.
  Widget _buildFooterLink() {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller.footerFade,
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sudah punya akun? ',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: controller.onRegister,
            child: Text(
              'Daftar',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Placeholder widgets ───

  Widget _buildCharacterPlaceholder() {
    return Center(
      child: Container(
        width: 220,
        height: 320,
        decoration: BoxDecoration(
          color: _LoginColors.cardGreen.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline_rounded,
              size: 80,
              color: _LoginColors.cardGreen.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _LoginColors.cardGreen.withValues(alpha: 0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
