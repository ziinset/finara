import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenH = mq.size.height;
    final screenW = mq.size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF000000),
        body: Stack(
          children: [
            // ── Green glow pencahayaan – bottom-left ──
          Positioned(
  left: -screenW * 0.08,
  bottom: -screenH * 0.14,
  child: ImageFiltered(
    imageFilter: ImageFilter.blur(
      sigmaX: 80,
      sigmaY: 80,
    ),
    child: Container(
      width: screenW * 1.05,
      height: screenW * 1.05,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
gradient: RadialGradient(
  center: const Alignment(-0.15, 0.20),
  radius: 1.15,
  colors: [
    const Color(0xFF6FD08A).withOpacity(0.30),
    const Color(0xFF4F8B5C).withOpacity(0.18),
    const Color(0xFF27452F).withOpacity(0.08),
    Colors.transparent,
  ],
  stops: const [
    0.0,
    0.28,
    0.62,
    1.0,
  ],
),
      ),
    ),
  ),
),

            // ── Main content ──
            SizedBox.expand(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status bar spacer – judul agak ke bawah
                  SizedBox(height: mq.padding.top + 72),

                  // ── Headline + description ──
                  _animated(
                    fade: controller.contentFade,
                    slide: controller.contentSlide,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text(
      'Manage',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 50,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        letterSpacing: -0.8,
      ),
    ),

    const Text(
      'Your Finances',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 50,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        letterSpacing: -0.8,
      ),
    ),
  ],
),
                          const SizedBox(height: 24),

Text(
  'Empower your money,\nsimplify your life.',
  style: TextStyle(
    fontFamily: 'Inter',
    fontSize: 21,
    fontWeight: FontWeight.w500,
    height: 1.50, // atau 1.48
    color: const Color(0xFFA9A9A9), // sedikit lebih gelap dari sebelumnya
  ),
),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Cards section ──
                  Expanded(
                    child: _animated(
                      fade: controller.blackCardFade,
                      slide: controller.blackCardSlide,
                      child: _buildCardsSection(screenW, screenH),
                    ),
                  ),

                  // ── Footer: dots + button ──
                  _animated(
                    fade: controller.buttonFade,
                    slide: controller.buttonSlide,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
  32,
  0,
  32,
  mq.padding.bottom + 56,
),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Page dots
                          Row(
                            children: List.generate(3, (i) {
                              final isActive = i == 0;
                        return AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  margin: const EdgeInsets.only(right: 5),

  // aktif lebih panjang, yang tidak aktif juga capsule
  width: isActive ? 42 : 14,
  height: 7,

  decoration: BoxDecoration(
    color: isActive
        ? Colors.white
        : Colors.white.withOpacity(0.28),
    borderRadius: BorderRadius.circular(20),
  ),
);
                            }),
                          ),

                          // Arrow button – darker green circle
                          GestureDetector(
                            onTap: controller.onGetStarted,
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(
                                color: Color(0xFF3A6043),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  CARDS SECTION
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildCardsSection(double screenW, double screenH) {
   const cardW = 305.0;
const cardH = 195.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final areaH = constraints.maxHeight;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Back card – rotated +12°, lebih ke bawah & ke kanan ──
            Positioned(
              left: screenW * 0.17,
              top: areaH * 0.18,
              child: Transform.rotate(
                angle: 0.21, // ~12 degrees
                child:_buildGlassCard(
  width: cardW,
  height: cardH,
  opacity: 0.82,
  backgroundColor: const Color(0xFF3D3D3D),
  showBorder: true,
  child: _backCardContent(),
),
              ),
            ),

            // ── Front card – rotated -5°, lebih ke bawah & ke kanan ──
            Positioned(
              left: screenW * 0.10,
              top: areaH * 0.18 + 80,
              child: Transform.rotate(
                angle: -0.087, // ~-5 degrees
                child:_buildGlassCard(
  width: cardW,
  height: cardH,
  opacity: 1,
  backgroundColor: Colors.white,
  showBorder: false,
  child: _frontCardContent(),
),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Glassmorphism card shell ──
 Widget _buildGlassCard({
  required double width,
  required double height,
  required Widget child,
  double opacity = 1.0,
  Color? backgroundColor,
  bool showBorder = true,
}) {
    return Opacity(
      opacity: opacity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
          child: Container(
            width: width,
            height: height,
         decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(24),

  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      backgroundColor!.withOpacity(0.12),
      backgroundColor.withOpacity(0.08),
      backgroundColor.withOpacity(0.04),
    ],
  ),

  border: showBorder
      ? Border.all(
          color: Colors.white.withOpacity(0.35),
          width: 1.3,
        )
      : null,

  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      blurRadius: 32,
      offset: const Offset(0, 10),
    ),
  ],
),
            child: child,
          ),
        ),
      ),
    );
  }

  // ── Back card content ($7,630.25) ──
  Widget _backCardContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Balance',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.60),
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '\$7,630.25',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '•••• 3482',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.60),
                  fontSize: 11,
                  letterSpacing: 2,
                  fontFamily: 'Inter',
                ),
              ),
              // Mastercard-style double-circle
              Stack(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.40),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Positioned(
                    left: 14,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.20),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Front card content ($3,424.31) ──
  Widget _frontCardContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top row: balance + contactless icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Balance',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.60),
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '\$3,424.31',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              // Contactless / NFC icon
              Icon(
                Icons.wifi,
                color: Colors.white.withOpacity(0.80),
                size: 22,
              ),
            ],
          ),

          // Bottom row: dots + name / VISA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card number dots + suffix
                  Row(
                    children: [
                      ...List.generate(
                        4,
                        (_) => Container(
                          width: 5,
                          height: 5,
                          margin: const EdgeInsets.only(right: 3),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '2314',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Elena Maty',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              // VISA logo
              Text(
                'VISA',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.90),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  ANIMATION HELPER
  // ─────────────────────────────────────────────────────────────────────────

  Widget _animated({
    required Animation<double> fade,
    required Animation<Offset> slide,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, ch) {
        return SlideTransition(
          position: slide,
          child: FadeTransition(opacity: fade, child: ch),
        );
      },
      child: child,
    );
  }
}
