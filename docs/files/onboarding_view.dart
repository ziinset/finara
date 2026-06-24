// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../../core/theme/app_colors.dart';
// import '../controllers/onboarding_controller.dart';

// class OnboardingView extends GetView<OnboardingController> {
//   const OnboardingView({super.key});

//   static const _imgBlackCard =
//       'https://lh3.googleusercontent.com/aida-public/AB6AXuCtXHyq7eI2irrFwTJRT3EH4HuRBuWWCV0ujPwdsmmVx7mpz1VSU74wueAcOC6cJJLWoYCRAMEikoX9ZMqypMmZ3K99LgQQaO6cPQRO8y8YzZCkqYD3GwIhvx8V3rRgndYQgxNkDfzEHPxpYy3q7JuPmUMCR2vBROEuAa8VcK5EsY8QN8G-iZ46Kg1-9NSTEflO596ERYVvalBpq-xyRx3DKmKkodLhopLQPbs8aqLq3lYMqSJxTB4nrE9n7MF4W28Bex5WZM2CkiL1';
//   static const _imgGreenCard =
//       'https://lh3.googleusercontent.com/aida-public/AB6AXuDSUwWvWLfvlNljUAuJUJaSPM6LyE6_TgpFF7Xv39cl1sah0mYlGr6onl31StscvaNVXRNgCo4lI3SuGT6Q2T4XEIZk1M8GG--a6xWNARD32-7IlsPsULsG1VJpyfY0codXWcdnWN5USEk_bVIP9O8prNGFWbec7--L2ZBOv7YZliLavHhILUo5fOdhCUHqKHvycw3T88kRVSx0rEfMcY1SdWI2Te02lpoIUY5Ia8LezkFAwZSmswmcy5inEWrV1TxS1iH5q3jUmNqD';
//   static const _imgCharacter =
//       'https://lh3.googleusercontent.com/aida-public/AB6AXuDPvvhnCWRZx45LegLiUr5LxScln-xTmwAzF3T0bCdnok4usc4IFJ6nuLxpcOPri7a7FZeTNHifM7s4838eH-iv3gpTFl3h34jSGYsV01nq7TW1JA8fw1ig3Cg_QqhdRwrahKgAh21FCqScli8eu4mYuT8QUSQQ5aNByyIHZp0dQuldusZiabvvktNRuNWynaSlfZs69FjC29BlTtlf8AGIxV0_h0dSYC1nyySODNR1T79ikE_jbw_remaubdJ_rpQf6w_g7L_dB_fO';
//   static const _imgBadge =
//       'https://lh3.googleusercontent.com/aida-public/AB6AXuB7B9OCnc7pZOSW77iI3aq5-vpnVNiZ4Nwai2FDGufK8wmRTQdG0OTwUdmvSkp014OazI5OJBeiEG4ljpGqICaxWK6hf4qur8-na5ahigIwcpzd0GnDjHo1LpCsn6E8DH6637UG0d5RIXs8wY-2YsT1VGT9IUp8xoNtgOSdRukONtPgii7Jd9jXf9fTueEuFDXl8hEYp0BUVeh_cFYsNukCpb7KvxpT2Xnh77SbTRpZ7IBgO_REO99JNke_2vI-rX5Ky3oa1tXFB';
//   static const _imgLogo =
//       'https://lh3.googleusercontent.com/aida-public/AB6AXuAtEptVrIXFPTj7JhEyW5HptOFWENYJnV0m_mR2wsLO8lN7QsjAR8cyfhFYFlX5X8hEjKXhQkcJ3el-YGi5vEQ3iZlma8hbbQLH9b6ljN5nkCXLbBeLJFli6nYHX7aJ4jqRkAsNABhLGChjfdJM4uYvJ-BbPAAqcqO2nDwKzmzLtl65S190HkGC7Ts0CoaUXfAFTGamkj2iLXm2zDLeCdxuyRNFTEUBFDc1y2b4INbBtoZfdI2WQsSEWn2NZI59oQOBbD0y99M0eNmE';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(),
//             Expanded(child: _buildIllustration()),
//             _buildBottomContent(),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Header ──────────────────────────────────────────
//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//       child: Image.network(
//         _imgLogo,
//         height: 40,
//         fit: BoxFit.contain,
//         errorBuilder: (_, __, ___) => const Text(
//           'FinGrowth',
//           style: TextStyle(
//             fontFamily: 'Poppins',
//             fontSize: 22,
//             fontWeight: FontWeight.w700,
//             color: AppColors.primary,
//           ),
//         ),
//       ),
//     );
//   }

//   // ── Illustration Stack ───────────────────────────────
//   Widget _buildIllustration() {
//     return Center(
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final w = constraints.maxWidth.clamp(0.0, 400.0);
//           const h = 350.0;
//           return SizedBox(
//             width: w,
//             height: h,
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 // Black card — back layer
//                 Positioned(
//                   left: w * 0.0,
//                   top: h * 0.10,
//                   child: Transform.rotate(
//                     angle: -12 * 3.14159 / 180,
//                     child: _CardImage(url: _imgBlackCard, width: w * 0.65),
//                   ),
//                 ),

//                 // Green card — middle layer
//                 Positioned(
//                   right: w * 0.05,
//                   bottom: h * 0.10,
//                   child: Transform.rotate(
//                     angle: 3 * 3.14159 / 180,
//                     child: _CardImage(url: _imgGreenCard, width: w * 0.75),
//                   ),
//                 ),

//                 // Floating "+" button
//                 Positioned(
//                   top: h * 0.10,
//                   right: w * 0.35,
//                   child: const _PlusButton(),
//                 ),

//                 // Character — foreground
//                 Positioned(
//                   bottom: -20,
//                   right: w * 0.05,
//                   child: Image.network(
//                     _imgCharacter,
//                     width: w * 0.65,
//                     fit: BoxFit.contain,
//                     errorBuilder: (_, __, ___) => const SizedBox.shrink(),
//                   ),
//                 ),

//                 // Badge — top layer
//                 Positioned(
//                   bottom: 0,
//                   right: w * 0.10,
//                   child: Transform.rotate(
//                     angle: 12 * 3.14159 / 180,
//                     child: Image.network(
//                       _imgBadge,
//                       width: w * 0.45,
//                       fit: BoxFit.contain,
//                       errorBuilder: (_, __, ___) => const SizedBox.shrink(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // ── Bottom Content ───────────────────────────────────
//   Widget _buildBottomContent() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Good\nfinances,\nbetter life.',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontSize: 44,
//               height: 1.18,
//               fontWeight: FontWeight.w700,
//               letterSpacing: -0.88,
//               color: AppColors.headlineColor,
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Kelola keuanganmu dengan cerdas. '
//             'Lacak pengeluaran, tabungan, dan investasi '
//             'dalam satu tempat.',
//             style: TextStyle(
//               fontFamily: 'Inter',
//               fontSize: 16,
//               height: 1.5,
//               fontWeight: FontWeight.w400,
//               color: AppColors.secondary,
//             ),
//           ),
//           const SizedBox(height: 24),
//           SizedBox(
//             width: double.infinity,
//             child: _GetStartedButton(onPressed: controller.onGetStarted),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────
// // Private sub-widgets (hanya dipakai di file ini)
// // ─────────────────────────────────────────

// class _CardImage extends StatelessWidget {
//   const _CardImage({required this.url, required this.width});
//   final String url;
//   final double width;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF201B10).withOpacity(0.10),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//             spreadRadius: -5,
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: Image.network(
//           url,
//           fit: BoxFit.cover,
//           errorBuilder: (_, __, ___) => const SizedBox.shrink(),
//         ),
//       ),
//     );
//   }
// }

// class _PlusButton extends StatelessWidget {
//   const _PlusButton();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 48,
//       height: 48,
//       decoration: BoxDecoration(
//         color: AppColors.tertiaryFixed,
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF201B10).withOpacity(0.10),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//             spreadRadius: -5,
//           ),
//         ],
//       ),
//       child: const Icon(
//         Icons.add,
//         color: AppColors.onTertiaryContainer,
//         size: 24,
//       ),
//     );
//   }
// }

// class _GetStartedButton extends StatelessWidget {
//   const _GetStartedButton({required this.onPressed});
//   final VoidCallback onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: AppColors.primary,
//       borderRadius: BorderRadius.circular(16),
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 18),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFF201B10).withOpacity(0.12),
//                 blurRadius: 20,
//                 offset: const Offset(0, 10),
//                 spreadRadius: -5,
//               ),
//             ],
//           ),
//           alignment: Alignment.center,
//           child: const Text(
//             'Get started',
//             style: TextStyle(
//               fontFamily: 'Inter',
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: AppColors.onPrimary,
//               letterSpacing: 0.1,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
