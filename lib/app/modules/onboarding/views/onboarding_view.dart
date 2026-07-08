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
        backgroundColor: const Color(0xFF111111),
        body: Stack(
          children: [
            // ── Dark base overlay for blackish atmosphere ──
            Positioned.fill(
              child: Container(
                color: const Color(0xFF0A0A0A).withOpacity(0.45),
              ),
            ),

            // ── Green glow: bottom-left, very large, super-blurred (darker green) ──
            Positioned(
              left: -screenW * 0.35,
              bottom: -screenH * 0.08,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 180, sigmaY: 180),
                child: Container(
                  width: screenW * 1.1,
                  height: screenW * 1.1,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E4A2A).withOpacity(0.55),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            // ── Main content ──
            SizedBox.expand(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top spacer + headline pushed down for visual centering ──
                  SizedBox(height: mq.padding.top + screenH * 0.12),

                  // ── Headline + description ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: _animated(
                      fade: controller.contentFade,
                      slide: controller.contentSlide,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Manage\nYour Finances',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 44,
                              fontWeight: FontWeight.w400, // regular, not bold
                              height: 1.1,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Empower your money,\nsimplify your life.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              color: Color(0xFFAAAAAA),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Cards section grows to fill remaining space ──
                  Expanded(
                    child: _animated(
                      fade: controller.blackCardFade,
                      slide: controller.blackCardSlide,
                      child: _buildCardsSection(screenW, screenH),
                    ),
                  ),

                  // ── Bottom: Dots + Arrow button ──
                  _animated(
                    fade: controller.buttonFade,
                    slide: controller.buttonSlide,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          28, 0, 28, mq.padding.bottom + 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Page dots
                          Row(
                            children: List.generate(3, (i) {
                              final isActive = i == 0;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(right: 7),
                                width: isActive ? 28 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            }),
                          ),

                          // Arrow button
                          GestureDetector(
                            onTap: controller.onGetStarted,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: Color(0xFF5CBB7A),
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

  Widget _buildCardsSection(double screenW, double screenH) {
    final cardW = screenW * 0.82; // lebih besar
    final cardH = cardW * 0.58;

    return LayoutBuilder(
      builder: (context, constraints) {
        final areaH = constraints.maxHeight;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Card behind: dark, tilted clockwise ──
            Positioned(
              left: screenW * 0.06,
              top: areaH * 0.12,
              child: Transform.rotate(
                angle: 0.18,
                child: _buildFinanceCard(
                  width: cardW,
                  height: cardH,
                  backgroundColor: const Color(0xFF252525),
                  balance: '\$7,630.25',
                  label: 'Balance',
                  showContactless: false,
                  showVisa: false,
                  showDots: false,
                  showName: false,
                  isTransparent: false,
                ),
              ),
            ),

            // ── Card front: glassmorphism, more transparent ──
            Positioned(
              left: screenW * 0.04,
              top: areaH * 0.30,
              child: Transform.rotate(
                angle: -0.06,
                child: _buildFinanceCard(
                  width: cardW,
                  height: cardH,
                  backgroundColor: const Color(0xFF1A1A1A).withOpacity(0.10),
                  balance: '\$3,424.31',
                  label: 'Balance',
                  showContactless: true,
                  showVisa: true,
                  showDots: true,
                  showName: true,
                  cardNumSuffix: '2314',
                  cardOwner: 'Elena Maty',
                  isTransparent: true,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFinanceCard({
    required double width,
    required double height,
    required Color backgroundColor,
    required String balance,
    required String label,
    bool showContactless = false,
    bool showVisa = false,
    bool showDots = false,
    bool showName = false,
    bool isTransparent = false,
    String cardNumSuffix = '',
    String cardOwner = '',
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: isTransparent
            ? ImageFilter.blur(sigmaX: 32, sigmaY: 32)
            : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(22),
            border: isTransparent
                ? Border.all(
                    color: Colors.white.withOpacity(0.08),
                    width: 1,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.45),
                blurRadius: 40,
                spreadRadius: 2,
                offset: const Offset(0, 18),
              )
            ],
          ),
         padding: EdgeInsets.zero,
child: Stack(
  children: [

    Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        95,
        20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
              ),
              if (showContactless)
                const Icon(
                  Icons.wifi,
                  color: Color(0xFF888888),
                  size: 18,
                ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            balance,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              if (showDots || showName)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    if (showDots)
                      Row(
                        children: [
                          ...List.generate(
                            4,
                            (_) => Container(
                              width: 5,
                              height: 5,
                              margin: const EdgeInsets.only(right: 3),
                              decoration: const BoxDecoration(
                                color: Color(0xFF3A7A50), // hijau lebih gelap
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),

                          const SizedBox(width: 6),

                          Text(
                            cardNumSuffix,
                            style: const TextStyle(
                              color: Color(0xFFAAAAAA),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                    if (showName) ...[
                      const SizedBox(height: 2),
                      Text(
                        cardOwner,
                        style: const TextStyle(
                          color: Color(0xFFCCCCCC),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                )
              else
                const SizedBox(),

              if (showVisa)
                const Text(
                  'VISA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
            ],
          ),
        ],
      ),
    ),

    if (isTransparent)
      Positioned(
        right: 4,
        bottom: -2,
        child: Opacity(
          opacity: 0.38, // lebih transparan
          child: Image.asset(
            'assets/images/1.png',
            width: width * 0.44,
            fit: BoxFit.contain,
          ),
        ),
      ),
  ],
),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  HELPERS
  // ──────────────────────────────────────────────────────────────────────────

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
