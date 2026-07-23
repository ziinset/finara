import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import 'edit_password_view.dart';
import 'ekspor_data_view.dart';
import 'notifikasi_view.dart';
import 'profil_saya_view.dart';

// ─── Color Palette — Terra Finance Dark (Deep Forest) ─────────────────────────
// Sesuai DESIGN.md & code.html stitch_user_profile_dark_mode
class _C {
  _C._();

  // Background & Surfaces
  static const Color background         = Color(0xFF101411); // surface / background
  static const Color surfaceContLow     = Color(0xFF181D19); // surface-container-low
  static const Color surfaceCont        = Color(0xFF1D211E); // surface-container
  static const Color surfaceContHighest = Color(0xFF313531); // surface-container-highest

  // Primary (illuminated forest green)
  static const Color primary            = Color(0xFFB1CEB5); // primary
  static const Color primaryContainer   = Color(0xFF344C3A); // primary-container
  static const Color onPrimary          = Color(0xFF003920); // on-primary

  // Secondary (gold/yellow accent)
  static const Color secondary          = Color(0xFFE3C53C);
  static const Color secondaryContainer = Color(0xFF534600);
  static const Color onSecondaryContainer = Color(0xFFFFE262);

  // On-Surface (text)
  static const Color onSurface         = Color(0xFFE1E3DE); // on-surface
  static const Color onSurfaceVariant  = Color(0xFFC2C8C0); // on-surface-variant

  // Outline
  static const Color outlineVariant    = Color(0xFF424843);

  // Error
  static const Color error             = Color(0xFFFFB4AB);
  static const Color errorContainer    = Color(0xFF93000A);

  // Helpers
  static const Color cardBg            = Color(0xFF1F1F1F); // card background (matches HTML inline style)
}

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Responsive helpers ──
    final mq = MediaQuery.of(context);
    final screenH = mq.size.height;
    final bottomInset = mq.padding.bottom;
    // Nav bar is typically ~80 logical pixels. Add safe area + extra buffer so
    // the logout button is always fully visible.
    final scrollBottomPad = bottomInset + 100.0;

    return Scaffold(
      backgroundColor: _C.background,
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: scrollBottomPad),
            child: Column(
              children: [
                // ─── Profile Header ───
                _buildProfileHeader(context, screenH),

                // ─── Content Sections ───
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Section
                      _buildSectionLabel(
                        icon: Icons.person_outline,
                        label: 'Profil',
                      ),
                      const SizedBox(height: 12),
                      _buildProfilCard(context),
                      const SizedBox(height: 32),

                      // Security Section
                      _buildSectionLabel(
                        icon: Icons.shield_outlined,
                        label: 'Keamanan Akun',
                      ),
                      const SizedBox(height: 12),
                      _buildSecurityCard(context),
                      const SizedBox(height: 32),

                      // Notifications Section
                      _buildSectionLabel(
                        icon: Icons.notifications_active_outlined,
                        label: 'Notifikasi & Pengingat',
                      ),
                      const SizedBox(height: 12),
                      _buildNotifikasiCard(),
                      const SizedBox(height: 32),

                      // Export Data Section
                      _buildEksporHeader(),
                      const SizedBox(height: 12),
                      _buildEksporGrid(),
                      const SizedBox(height: 32),

                      // Logout Button
                      _buildLogoutButton(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ─── Floating Top App Bar ─────────────────────────────────────────
          _buildTopAppBar(context),
        ],
      ),
    );
  }

  // ─── Top App Bar (fixed overlay, semi-transparent + blur) ─────────────────
  Widget _buildTopAppBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          bottom: 12,
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _C.background.withValues(alpha: 0.85),
              _C.background.withValues(alpha: 0.5),
              _C.background.withValues(alpha: 0.0),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: icon + title
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _C.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _C.outlineVariant.withValues(alpha: 0.30),
                    ),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: _C.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Profil',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _C.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),

            // Right: action buttons
            Row(
              children: [
                _buildAppBarButton(Icons.search),
                const SizedBox(width: 8),
                _buildAppBarButton(Icons.settings_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _C.surfaceContHighest.withValues(alpha: 0.40),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _C.outlineVariant.withValues(alpha: 0.20),
        ),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: _C.onSurfaceVariant),
        onPressed: () {},
        padding: EdgeInsets.zero,
      ),
    );
  }

  // ─── Profile Header ─────────────────────────────────────────────────────────
  Widget _buildProfileHeader(BuildContext context, double screenH) {
    final mq = MediaQuery.of(context);
    final topPad = mq.padding.top;

    // Responsive avatar size: smaller on short screens
    final avatarSize = screenH < 680 ? 100.0 : (screenH < 780 ? 120.0 : 144.0);
    final cameraSize = avatarSize * 0.27;
    final cameraIconSize = avatarSize * 0.13;
    // Header total height shrinks proportionally
    final headerHeight = topPad + (screenH < 680 ? 220.0 : (screenH < 780 ? 260.0 : 310.0));
    // Top padding before avatar
    final avatarTopPad = topPad + (screenH < 680 ? 52.0 : (screenH < 780 ? 62.0 : 72.0));
    // Name font size
    final nameFontSize = screenH < 680 ? 18.0 : (screenH < 780 ? 21.0 : 24.0);
    final emailFontSize = screenH < 680 ? 12.0 : 14.0;
    final spacer1 = screenH < 680 ? 12.0 : (screenH < 780 ? 16.0 : 20.0);
    final spacer2 = screenH < 680 ? 10.0 : 14.0;
    final spacer3 = screenH < 680 ? 16.0 : 28.0;

    return Stack(
      children: [
        // Gradient tonal background overlay
        Container(
          width: double.infinity,
          height: headerHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _C.primaryContainer.withValues(alpha: 0.20),
                _C.primaryContainer.withValues(alpha: 0.05),
                _C.background.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),

        // Avatar + Info
        Padding(
          padding: EdgeInsets.only(top: avatarTopPad),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar with camera button
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _C.surfaceContLow,
                          width: 6,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/img/Profile-Picture.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: _C.surfaceCont,
                            child: Icon(
                              Icons.person,
                              size: avatarSize * 0.42,
                              color: _C.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: cameraSize,
                          height: cameraSize,
                          decoration: BoxDecoration(
                            color: _C.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _C.surfaceContLow,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _C.primary.withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: _C.onPrimary,
                            size: cameraIconSize,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacer1),

                // Name
                Text(
                  'Goldi Arasseo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: nameFontSize,
                    fontWeight: FontWeight.w600,
                    color: _C.onSurface,
                  ),
                ),
                const SizedBox(height: 4),

                // Email
                Text(
                  'goldiarasseo@example.com',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: emailFontSize,
                    color: _C.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: spacer2),

                // Premium Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: _C.secondaryContainer,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: _C.secondary.withValues(alpha: 0.20),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.stars_rounded,
                        size: 16,
                        color: _C.onSecondaryContainer,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'PREMIUM MEMBER',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _C.onSecondaryContainer,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacer3),
              ],
            ),
          ),
        ),
      ],
    );
  }


  // ─── Section Label ───────────────────────────────────────────────────────────
  Widget _buildSectionLabel({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: _C.primary),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _C.onSurfaceVariant,
            letterSpacing: 2.2,
          ),
        ),
      ],
    );
  }

  // ─── Profil Card ─────────────────────────────────────────────────────────────
  Widget _buildProfilCard(BuildContext context) {
    return _DarkCard(
      child: InkWell(
        onTap: () => Get.to(() => const ProfilSayaView()),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              _iconBox(Icons.edit_outlined),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Profil',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: _C.onSurface,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Ubah nama, foto, dan data diri',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: _C.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: _C.onSurfaceVariant.withValues(alpha: 0.50),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Security Card ───────────────────────────────────────────────────────────
  Widget _buildSecurityCard(BuildContext context) {
    return _DarkCard(
      child: Column(
        children: [
          // Ubah Kata Sandi
          InkWell(
            onTap: () => Get.to(() => const EditPasswordView()),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  _iconBox(Icons.lock_open_outlined),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ubah Kata Sandi',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: _C.onSurface,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Pembaruan rutin disarankan',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: _C.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: _C.onSurfaceVariant.withValues(alpha: 0.50),
                  ),
                ],
              ),
            ),
          ),

          // Thin divider
          Divider(
            height: 1,
            thickness: 1,
            color: _C.outlineVariant.withValues(alpha: 0.15),
          ),

          // 2FA Toggle
          _TwoFAToggleItem(),
        ],
      ),
    );
  }

  // ─── Notifikasi Card ─────────────────────────────────────────────────────────
  Widget _buildNotifikasiCard() {
    return _DarkCard(
      child: Column(
        children: [
          // Ringkasan Harian Toggle
          _DailyReminderToggleItem(),

          // Thin divider
          Divider(
            height: 1,
            thickness: 1,
            color: _C.outlineVariant.withValues(alpha: 0.15),
          ),

          // Custom Reminders
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _C.surfaceCont.withValues(alpha: 0.30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pengingat Kustom',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: _C.onSurface,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.to(
                        () => const NotifikasiView(),
                        transition: Transition.rightToLeft,
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: _C.primary.withValues(alpha: 0.10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        '+ TAMBAH',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _C.primary,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildReminderItem(
                  title: 'Pengingat Gajian',
                  time: 'Tgl 25 • 09:00 AM',
                  isActive: true,
                ),
                const SizedBox(height: 10),
                _buildReminderItem(
                  title: 'Bayar Listrik',
                  time: 'Tgl 05 • 10:00 AM',
                  isActive: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderItem({
    required String title,
    required String time,
    required bool isActive,
  }) {
    return Opacity(
      opacity: isActive ? 1.0 : 0.55,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _C.surfaceContLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _C.outlineVariant.withValues(alpha: 0.10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Accent bar
            Container(
              width: 5,
              height: 40,
              decoration: BoxDecoration(
                color: isActive
                    ? _C.primary.withValues(alpha: 0.40)
                    : _C.outlineVariant.withValues(alpha: 0.40),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _C.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.event_outlined,
                        size: 13,
                        color: _C.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: _C.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: _C.onSurfaceVariant,
              ),
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  // ─── Ekspor Data ─────────────────────────────────────────────────────────────
  Widget _buildEksporHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.folder_zip_outlined,
              size: 20,
              color: _C.primary,
            ),
            const SizedBox(width: 8),
            const Text(
              'EKSPOR DATA',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _C.onSurfaceVariant,
                letterSpacing: 2.2,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _C.primary.withValues(alpha: 0.90),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'PREMIUM ONLY',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: _C.onPrimary,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEksporGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildEksporCard(
            icon: Icons.description_rounded,
            iconBgColor: _C.primaryContainer.withValues(alpha: 0.30),
            iconColor: _C.primary,
            ringColor: _C.primaryContainer.withValues(alpha: 0.10),
            label: 'Excel',
            format: 'Format .xlsx',
            eksporFormat: EksporFormat.excel,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildEksporCard(
            icon: Icons.picture_as_pdf_rounded,
            iconBgColor: _C.errorContainer.withValues(alpha: 0.20),
            iconColor: _C.error,
            ringColor: _C.errorContainer.withValues(alpha: 0.10),
            label: 'PDF',
            format: 'Format .pdf',
            eksporFormat: EksporFormat.pdf,
          ),
        ),
      ],
    );
  }

  Widget _buildEksporCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required Color ringColor,
    required String label,
    required String format,
    required EksporFormat eksporFormat,
  }) {
    return Builder(
      builder: (ctx) => GestureDetector(
        onTap: () => EksporDataModal.show(ctx, format: eksporFormat),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _C.cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _C.outlineVariant.withValues(alpha: 0.10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ringColor, width: 3),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: _C.onSurface,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                format,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: _C.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Logout Button ───────────────────────────────────────────────────────────
  Widget _buildLogoutButton() {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          Get.defaultDialog(
            title: 'Keluar',
            middleText: 'Apakah Anda yakin ingin keluar dari akun ini?',
            textConfirm: 'Keluar',
            textCancel: 'Batal',
            confirmTextColor: _C.onPrimary,
            buttonColor: _C.error,
            cancelTextColor: _C.onSurface,
            backgroundColor: _C.surfaceCont,
            titleStyle: const TextStyle(color: _C.onSurface),
            middleTextStyle: const TextStyle(color: _C.onSurfaceVariant),
            onConfirm: () {
              Get.back();
              Get.snackbar(
                'Berhasil',
                'Anda telah berhasil logout.',
                backgroundColor: _C.surfaceContLow,
                colorText: _C.onSurface,
              );
            },
          );
        },
        icon: const Icon(Icons.logout, color: _C.error, size: 22),
        label: const Text(
          'Keluar dari Akun',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: _C.error,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: _C.error.withValues(alpha: 0.0),
            ),
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.all(
            _C.error.withValues(alpha: 0.08),
          ),
        ),
      ),
    );
  }

  // ─── Shared icon box helper ──────────────────────────────────────────────────
  Widget _iconBox(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _C.primaryContainer.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: _C.primary, size: 22),
    );
  }
}

// ─── Dark Card container ──────────────────────────────────────────────────────
class _DarkCard extends StatelessWidget {
  const _DarkCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _C.outlineVariant.withValues(alpha: 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

// ─── 2FA Toggle ──────────────────────────────────────────────────────────────
class _TwoFAToggleItem extends StatefulWidget {
  @override
  State<_TwoFAToggleItem> createState() => _TwoFAToggleItemState();
}

class _TwoFAToggleItemState extends State<_TwoFAToggleItem> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _C.primaryContainer.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: _C.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Autentikasi 2 Faktor',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: _C.onSurface,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Amankan login Anda',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: _C.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _enabled,
            onChanged: (val) {
              setState(() => _enabled = val);
              Get.snackbar(
                'Status 2FA',
                val ? '2FA berhasil diaktifkan' : '2FA dinonaktifkan',
                backgroundColor: _C.surfaceContLow,
                colorText: _C.primary,
              );
            },
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return _C.primary;
              return _C.surfaceContHighest;
            }),
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return _C.onPrimary;
              return _C.onSurfaceVariant;
            }),
          ),
        ],
      ),
    );
  }
}

// ─── Daily Reminder Toggle ─────────────────────────────────────────────────────
class _DailyReminderToggleItem extends StatefulWidget {
  @override
  State<_DailyReminderToggleItem> createState() =>
      _DailyReminderToggleItemState();
}

class _DailyReminderToggleItemState extends State<_DailyReminderToggleItem> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _C.primaryContainer.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.auto_graph,
              color: _C.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ringkasan Harian',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: _C.onSurface,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Tiap hari jam 20:00 WIB',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: _C.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _enabled,
            onChanged: (val) => setState(() => _enabled = val),
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return _C.primary;
              return _C.surfaceContHighest;
            }),
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return _C.onPrimary;
              return _C.onSurfaceVariant;
            }),
          ),
        ],
      ),
    );
  }
}
