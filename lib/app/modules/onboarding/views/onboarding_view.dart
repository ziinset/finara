import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

/// Design-system colors from DESIGN.md — "Organic Growth" palette.
class _C {
  _C._();
  static const Color primary = Color(0xFF223C27);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF5D5F58);
  static const Color tertiaryFixed = Color(0xFFFFE25F);
  static const Color onTertiaryContainer = Color(0xFF4B3F00);
  static const Color background = Color(0xFFEAEADE);

  // Semantic / component-specific
  static const Color headingText = Color(0xFF4A3933);
  static const Color badgeBg = Color(0xFFFFFFFF);
  static const Color badgeText = Color(0xFF40342B);
}

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenH = mq.size.height;
    final screenW = mq.size.width;
    final topPad = mq.padding.top;
    final botPad = mq.padding.bottom;

    // ── Responsive scale factor based on a 812pt reference height (iPhone X) ──
    final double vScale = (screenH / 812).clamp(0.55, 1.3);
    final double hScale = (screenW / 375).clamp(0.55, 1.3);

    // ── Illustration section gets ~55% of available height on reference,
    //    but adapts for short screens ──
    final double illustrationHeight = screenH * (vScale < 0.85 ? 0.48 : 0.55);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _C.background,
        body: SizedBox.expand(
          child: Column(
            children: [
              // ─── Top illustration section (fixed height) ───
              SizedBox(
                height: illustrationHeight,
                child: _buildIllustrationSection(
                  context,
                  screenW,
                  illustrationHeight,
                  topPad,
                  vScale,
                  hScale,
                ),
              ),

              // ─── Bottom content section (fills remaining, scrollable) ───
              Expanded(
                child: _buildBottomContent(context, botPad, vScale, hScale),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  TOP SECTION — logo + overlapping card illustrations + character + badge
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildIllustrationSection(
    BuildContext context,
    double w,
    double sectionH,
    double topPad,
    double vScale,
    double hScale,
  ) {
    // Scale element sizes proportionally
    final double logoW = 32 * hScale;
    final double logoH = 44 * vScale;
    final double plusSize = (48 * vScale).clamp(36.0, 56.0);
    final double plusIcon = (26 * vScale).clamp(20.0, 32.0);
    final double badgePadH = (20 * hScale).clamp(12.0, 24.0);
    final double badgePadV = (12 * vScale).clamp(8.0, 16.0);
    final double badgeFontSize = (14 * hScale).clamp(11.0, 16.0);
    final double badgeIconSize = (16 * hScale).clamp(12.0, 20.0);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: _C.background),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Logo (top-left) ──
          Positioned(
            top: topPad + 16 * vScale,
            left: 24 * hScale,
            child: _animated(
              fade: controller.logoFade,
              slide: controller.logoSlide,
              child: SvgPicture.asset(
                'assets/svg/logo.svg',
                width: logoW,
                height: logoH,
              ),
            ),
          ),

          // ── Black card — behind, tilted left ──
          Positioned(
            left: -w * 0.05,
            top: sectionH * 0.14,
            child: _animated(
              fade: controller.blackCardFade,
              slide: controller.blackCardSlide,
              child: Transform.rotate(
                angle: -0.21, // ≈ -12°
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [_naturalShadow()],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SvgPicture.asset(
                      'assets/svg/kartu-hitam-onboarding.svg',
                      width: w * 0.62,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Green card — overlapping, tilted right ──
          Positioned(
            right: -w * 0.02,
            bottom: sectionH * 0.04,
            child: _animated(
              fade: controller.greenCardFade,
              slide: controller.greenCardSlide,
              child: Transform.rotate(
                angle: 0.052, // ≈ 3°
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [_naturalShadow()],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SvgPicture.asset(
                      'assets/svg/kartu-hijau-onboarding.svg',
                      width: w * 0.78,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Yellow "+" floating button ──
          Positioned(
            top: sectionH * 0.14,
            right: w * 0.28,
            child: _animated(
              fade: controller.plusButtonFade,
              slide: controller.plusButtonSlide,
              child: Container(
                width: plusSize,
                height: plusSize,
                decoration: BoxDecoration(
                  color: _C.tertiaryFixed,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _C.tertiaryFixed.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: _C.onTertiaryContainer,
                  size: plusIcon,
                ),
              ),
            ),
          ),

          // ── Character illustration ──
          Positioned(
            right: -w * 0.04,
            bottom: -sectionH * 0.05,
            child: _animated(
              fade: controller.characterFade,
              slide: controller.characterSlide,
              child: Image.asset(
                'assets/images/ilustrasi_cewek_onboarding.png',
                height: sectionH * 0.75,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // ── Floating badge ("Lorem ipsum") ──
          Positioned(
            bottom: 0,
            right: w * 0.06,
            child: _animated(
              fade: controller.badgeFade,
              slide: controller.badgeSlide,
              child: Transform.rotate(
                angle: 0.21, // ≈ 12°
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: badgePadH,
                    vertical: badgePadV,
                  ),
                  decoration: BoxDecoration(
                    color: _C.badgeBg,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.rotate(
                        angle: -0.785, // arrow ↗
                        child: Icon(
                          Icons.arrow_forward,
                          size: badgeIconSize,
                          color: _C.badgeText,
                        ),
                      ),
                      SizedBox(width: 8 * hScale),
                      Text(
                        'Lorem ipsum',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: badgeFontSize,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: _C.badgeText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  BOTTOM SECTION — headline, body, CTA button
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildBottomContent(
    BuildContext context,
    double bottomPadding,
    double vScale,
    double hScale,
  ) {
    // ── Responsive typography ──
    final double headlineFontSize = (42 * vScale).clamp(26.0, 48.0);
    final double bodyFontSize = (16 * vScale).clamp(13.0, 18.0);
    final double btnFontSize = (16 * vScale).clamp(14.0, 18.0);
    final double btnHeight = (56 * vScale).clamp(44.0, 64.0);
    final double hPad = (24 * hScale).clamp(16.0, 32.0);
    final double topContentPad = (32 * vScale).clamp(16.0, 40.0);
    final double headlineBodyGap = (16 * vScale).clamp(8.0, 20.0);

    return _animated(
      fade: controller.contentFade,
      slide: controller.contentSlide,
      child: Container(
        width: double.infinity,
        color: _C.background,
        padding: EdgeInsets.fromLTRB(hPad, topContentPad, hPad, 0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Headline ──
                      Text(
                        'Good\nfinances,\nbetter life.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: headlineFontSize,
                          fontWeight: FontWeight.w600,
                          height: 1.12,
                          color: _C.headingText,
                          letterSpacing: -0.8,
                        ),
                      ),

                      SizedBox(height: headlineBodyGap),

                      // ── Body text ──
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                        'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: bodyFontSize,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: _C.secondary.withValues(alpha: 0.85),
                        ),
                      ),

                      const Spacer(),

                      SizedBox(height: headlineBodyGap),

                      // ── CTA Button ──
                      _animated(
                        fade: controller.buttonFade,
                        slide: controller.buttonSlide,
                        child: SizedBox(
                          width: double.infinity,
                          height: btnHeight,
                          child: ElevatedButton(
                            onPressed: controller.onGetStarted,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _C.primary,
                              foregroundColor: _C.onPrimary,
                              elevation: 0,
                              shadowColor: _C.primary.withValues(alpha: 0.25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Get started',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: btnFontSize,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: bottomPadding > 0 ? bottomPadding : 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  HELPERS
  // ──────────────────────────────────────────────────────────────────────────

  /// Wraps [child] with coordinated fade + slide transitions.
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

  /// "Natural Drop" shadow per DESIGN.md — soft, diffused, warm-tinted.
  BoxShadow _naturalShadow() {
    return BoxShadow(
      color: const Color(0xFF201B10).withValues(alpha: 0.10),
      blurRadius: 20,
      offset: const Offset(0, 10),
      spreadRadius: -5,
    );
  }
}
