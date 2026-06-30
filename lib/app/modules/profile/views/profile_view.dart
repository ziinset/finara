import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controllers/profile_controller.dart';
import 'profil_saya_view.dart';
import 'keamanan_view.dart';
import 'notifikasi_view.dart';
import 'ekspor_data_view.dart';

class _C {
  _C._();
  static const Color background = Color(0xFFEBEBE0);
  static const Color primaryGreen = Color(0xFF3A6043);
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textBrown = Color(0xFF4A3933);
  static const Color textRed = Color(0xFFD32F2F);
}

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ─── Header with Curve and Avatar ───
            _buildHeader(context),

            // ─── Profile Information ───
            const SizedBox(height: 12),
            const Text(
              'Goldi Arasseo',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _C.textDark,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'loremipsum@gmail.com',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: _C.textDark,
              ),
            ),
            const SizedBox(height: 24),

            // ─── Promo Banner ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildPromoBanner(),
            ),
            const SizedBox(height: 24),

            // ─── Menu Sections ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Akun'),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(icon: Icons.person_outline, title: 'Profil Saya', onTap: () => Get.to(() => const ProfilSayaView())),
                        _buildDivider(),
                        _buildMenuItem(icon: Icons.lock_outline, title: 'Keamanan', onTap: () => Get.to(() => const KeamananView())),
                        _buildDivider(),
                        _buildMenuItem(icon: Icons.notifications_none, title: 'Notifikasi', onTap: () => Get.to(() => const NotifikasiView())),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  _buildSectionTitle('Fitur Premium'),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          icon: Icons.download_rounded, 
                          title: 'Ekspor Data', 
                          isPremium: true,
                          onTap: () => Get.to(() => const EksporDataView()),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Lainnya'),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(icon: Icons.info_outline, title: 'Tentang Finara', onTap: () {
                          Get.defaultDialog(
                            title: 'Tentang Finara',
                            middleText: 'Versi 1.0.0\nAplikasi Pencatat Keuangan Berbasis Wallet.',
                            textConfirm: 'Tutup',
                            confirmTextColor: Colors.white,
                            buttonColor: const Color(0xFF3A6043),
                            onConfirm: () => Get.back(),
                          );
                        }),
                        _buildDivider(),
                        _buildMenuItem(icon: Icons.support_agent, title: 'Hubungi Dukungan', onTap: () {
                          Get.snackbar('Dukungan Finara', 'Silakan hubungi kami via email di support@finara.id', backgroundColor: Colors.white);
                        }),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.person_off_outlined, 
                          title: 'Hapus Akun', 
                          textColor: _C.textRed,
                          iconColor: _C.textRed,
                          onTap: () {
                            Get.defaultDialog(
                              title: 'Hapus Akun',
                              middleText: 'Yakin ingin menghapus akun secara permanen? Semua data keuangan Anda akan hilang dan tidak dapat dikembalikan.',
                              textConfirm: 'Hapus',
                              textCancel: 'Batal',
                              confirmTextColor: Colors.white,
                              buttonColor: _C.textRed,
                              cancelTextColor: Colors.black,
                              onConfirm: () {
                                Get.back();
                                Get.snackbar('Berhasil', 'Akun berhasil dihapus.', backgroundColor: Colors.white);
                              },
                            );
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.logout, 
                          title: 'Keluar', 
                          textColor: _C.textRed,
                          iconColor: _C.textRed,
                          hideArrow: true,
                          onTap: () {
                            Get.defaultDialog(
                              title: 'Keluar',
                              middleText: 'Apakah Anda yakin ingin keluar dari akun ini?',
                              textConfirm: 'Keluar',
                              textCancel: 'Batal',
                              confirmTextColor: Colors.white,
                              buttonColor: _C.textRed,
                              cancelTextColor: Colors.black,
                              onConfirm: () {
                                Get.back();
                                Get.snackbar('Berhasil', 'Anda telah berhasil logout.', backgroundColor: Colors.white);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  // Bottom spacing
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: _C.textBrown,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    // Header height including the curved dip
    final double headerHeight = 180 + MediaQuery.of(context).padding.top;
    final double avatarRadius = 54;

    return SizedBox(
      height: headerHeight + avatarRadius - 20,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Background Painter
          SizedBox(
            width: double.infinity,
            height: headerHeight,
            child: CustomPaint(
              painter: ProfileHeaderPainter(),
            ),
          ),
          // Avatar
          Positioned(
            bottom: 0,
            child: Stack(
              children: [
                // White border container
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: _C.background, // Match background color for smooth blending
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: const AssetImage('assets/img/Profile-Picture.png'),
                  ),
                ),
                // Camera Button
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return SizedBox(
      height: 170,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Green card background
          Container(
            width: double.infinity,
            height: 170,
            padding: const EdgeInsets.fromLTRB(20, 24, 140, 24), // Leave space on right
            decoration: BoxDecoration(
              color: _C.primaryGreen,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _C.primaryGreen.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Amankan masa\ndepanmu!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Setiap rupiah yang kamu sisihkan\nhari ini adalah batu bata untuk ketenangan\nhidupmu esok hari.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          // Illustration overlapping
          Positioned(
            right: -20,
            bottom: 0,
            child: SvgPicture.asset(
              'assets/svg/ilustrasi-insight-man.svg',
              height: 210, // Make it taller than the container to overlap
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
    bool hideArrow = false,
    bool isPremium = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: iconColor ?? _C.textBrown,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? _C.textBrown,
                ),
              ),
            ),
            if (isPremium)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFFD700)),
                ),
                child: const Text(
                  'PREMIUM',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB8860B),
                  ),
                ),
              ),
            if (!hideArrow)
              Icon(
                Icons.chevron_right,
                size: 24,
                color: textColor ?? Colors.black,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey[200],
      ),
    );
  }
}

// Custom Painter for the curved header
class ProfileHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _C.primaryGreen
      ..style = PaintingStyle.fill;

    final path = Path();
    // Top left
    path.lineTo(0, size.height - 50);

    // Curve down in the center
    final center = size.width / 2;
    const curveWidth = 120.0;
    const dipHeight = 40.0;

    path.lineTo(center - curveWidth / 2 - 20, size.height - 50);

    // Left curved corner entering the dip
    path.quadraticBezierTo(
      center - curveWidth / 2,
      size.height - 50,
      center - curveWidth / 2 + 10,
      size.height - 40,
    );

    // The dip curve (U shape)
    path.quadraticBezierTo(
      center,
      size.height + dipHeight, // Pull down
      center + curveWidth / 2 - 10,
      size.height - 40,
    );

    // Right curved corner exiting the dip
    path.quadraticBezierTo(
      center + curveWidth / 2,
      size.height - 50,
      center + curveWidth / 2 + 20,
      size.height - 50,
    );

    path.lineTo(size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
