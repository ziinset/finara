import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

/// Design system colors from DESIGN.md ("Organic Fintech" palette).
class _AppColors {
  static const Color background = Color(0xFFE9E9DE);
  static const Color primary = Color(0xFF3D5C45);
  static const Color primaryDark = Color(0xFF26442F);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color textHeading = Color(0xFF40342B);
  static const Color textBody = Color(0xFF7A7067);
  static const Color accent = Color(0xFFFFD93D);
  static const Color surfaceContainer = Color(0xFFFFEADD);
}

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _AppColors.background,
        body: SafeArea(
          top: false,
          child: SizedBox(
            height: screenHeight,
            child: Stack(
              children: [
                // ── Main scrollable content ──
                Column(
                  children: [
                    // ── Header / Logo ──
                    _buildHeader(context),

                    // ── Hero Illustration Area ──
                    Expanded(
                      flex: 55,
                      child: _buildHeroSection(context, screenWidth),
                    ),

                    // ── Text Content & Action Area ──
                    _buildBottomContent(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Top logo bar — mimics the HTML <header> with the "Bloom" brand.
  Widget _buildHeader(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return SlideTransition(
          position: controller.logoSlide,
          child: FadeTransition(
            opacity: controller.logoFade,
            child: child,
          ),
        );
      },
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.spa,
                color: _AppColors.primaryDark,
                size: 24,
              ),
              const SizedBox(width: 6),
              Text(
                'Bloom',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: _AppColors.primaryDark,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Hero section with layered illustration images.
  Widget _buildHeroSection(BuildContext context, double screenWidth) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // ── Background cards layer ──
        AnimatedBuilder(
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
          child: Positioned.fill(
            child: Center(
              child: Container(
                width: screenWidth * 0.85,
                constraints: const BoxConstraints(maxWidth: 360),
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBQxpvq0qv--3hzblXu4WUr-811fBMH65dXLgEmDcn9Kkb9j1s8oYuSSWhGkztbhEF-TrJAP7Vk-XQ12ZD4LKf2pjQmK8Aj21b-DS7c7Q1Xo9RfttAtqkX8NXRe994Lbisrj2OaQ95Cs-g4R1BEbaOEMoZV2bRx1nXcWnVYS69_FPR7bmMRb8oiTS10n_BqpowW3tidvOobVOeTkzXncGd7RaC2bJY9Qdx_fF422Irqo-Z5zFcQSVJubStpsEtb4m25x_yNtrX9t5zb',
                  fit: BoxFit.contain,
                  opacity: const AlwaysStoppedAnimation(0.9),
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderCard(screenWidth);
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildPlaceholderCard(screenWidth);
                  },
                ),
              ),
            ),
          ),
        ),

        // ── Main character illustration ──
        AnimatedBuilder(
          animation: controller.animationController,
          builder: (context, child) {
            return SlideTransition(
              position: controller.characterSlide,
              child: FadeTransition(
                opacity: controller.characterFade,
                child: child,
              ),
            );
          },
          child: Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuB06ywqykBPkc_QN_Js5cbyH63wUjwtS-2rjHO_9tze63lEHlWHF4eENniX-QQpJnaoXMAmFm_ER4LTmS1WIcBwiriXvzb43mdqRb-1FWmVeC3N2EsZmO3GROEHx1Jq9mz_PGmXD2mDpv9UQbEr1lpZJpnr5bF7BUwhUTKEAzJ2oHRyiB_CZTrt6Ra1OoLb9UMBlwaRTOB64hzeo0kCG0YsjeMZad7_hIaynSt-CJGjQoBfXHvOuTe_FyVm6bloMOxsNuAG5JRtJ-bR',
                  fit: BoxFit.contain,
                  height: double.infinity,
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
        ),

        // ── Floating badge ──
        AnimatedBuilder(
          animation: controller.animationController,
          builder: (context, child) {
            return SlideTransition(
              position: controller.badgeSlide,
              child: FadeTransition(
                opacity: controller.badgeFade,
                child: child,
              ),
            );
          },
          child: Positioned(
            top: 40,
            right: screenWidth * 0.05,
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBWEuimbVQ_SjRIsVe8SfhK-rFuDhnVAP4N_xb55ONtWVCyTpxCmNieU8Lr9Fv0SVCI7dD9b93uVp0apX-UsVphHj9ZJnPmofAMKT5ymr96r1uAGJB9M1pRzW8CSeDZXsdCfY3lccKVsARqw_sMm2JBVJLHahU45KdCL1vWvxj7uR-aLVoy7Tje_N9jFMDoBkOdLCIa2Mm8fVSxzh83vsjmErF6cmTsxRPtDhSZAx8qCBWtX7-sW0oUX1irIo4sikwMwoSO20uJYAsJ',
              width: 140,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return _buildBadgePlaceholder();
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _buildBadgePlaceholder();
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Bottom content section — headline, description, and CTA button.
  Widget _buildBottomContent(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return SlideTransition(
          position: controller.contentSlide,
          child: FadeTransition(
            opacity: controller.contentFade,
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: _AppColors.background.withValues(alpha: 0.85),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Headline ──
                Text(
                  'Good finances,\nbetter life.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 42,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                    color: _AppColors.textHeading,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 16),

                // ── Description ──
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing '
                  'elit. Sed do eiusmod tempor incididunt ut labore et '
                  'dolore magna aliqua.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: _AppColors.textBody,
                  ),
                ),

                const SizedBox(height: 28),

                // ── CTA Button ──
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.onGetStarted,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _AppColors.primary,
                      foregroundColor: _AppColors.onPrimary,
                      elevation: 0,
                      shadowColor: _AppColors.primary.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    child: Text(
                      'Get started',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Placeholder widgets (shown while images load or on error) ───

  Widget _buildPlaceholderCard(double screenWidth) {
    return Container(
      width: screenWidth * 0.85,
      height: 250,
      decoration: BoxDecoration(
        color: _AppColors.surfaceContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Icon(
          Icons.bar_chart_rounded,
          size: 64,
          color: _AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildCharacterPlaceholder() {
    return Center(
      child: Container(
        width: 200,
        height: 300,
        decoration: BoxDecoration(
          color: _AppColors.surfaceContainer.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(
          Icons.person_outline_rounded,
          size: 80,
          color: _AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
    );
  }

  Widget _buildBadgePlaceholder() {
    return Container(
      width: 140,
      height: 60,
      decoration: BoxDecoration(
        color: _AppColors.accent.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Icon(
          Icons.notifications_active_rounded,
          size: 28,
          color: _AppColors.textHeading.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
