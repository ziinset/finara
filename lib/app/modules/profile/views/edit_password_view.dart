import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─── Color Palette — Terra Finance Dark (Edit Password) ───────────────────────
// Sesuai code.html & DESIGN.md stitch_user_edit_password_dark_mode
class _C {
  _C._();

  // Background & Surfaces
  static const Color background         = Color(0xFF101411);
  static const Color surface            = Color(0xFF101411);
  static const Color surfaceContLow     = Color(0xFF181D19); // surface-container-low (card bg)
  static const Color surfaceContHighest = Color(0xFF313632); // surface-container-highest (input fill)

  // Primary (illuminated forest green)
  static const Color primary            = Color(0xFFB3D0B7);
  static const Color onPrimary          = Color(0xFF1E3726);
  static const Color primaryContainer   = Color(0xFF354E3C);
  static const Color onPrimaryContainer = Color(0xFFCEECCF);

  // Secondary (gold)
  static const Color secondary          = Color(0xFFDFC757);

  // On-Surface (text)
  static const Color onSurface         = Color(0xFFE1E3DE);
  static const Color onSurfaceVariant  = Color(0xFFC2C8C1);

  // Outline
  static const Color outline           = Color(0xFF8C938C);
  static const Color outlineVariant    = Color(0xFF424842);

  // Error
  static const Color error             = Color(0xFFFFB4AB);

  // Success (for button state)
  static const Color success           = Color(0xFF4CAF50);
}

class EditPasswordView extends StatefulWidget {
  const EditPasswordView({super.key});

  @override
  State<EditPasswordView> createState() => _EditPasswordViewState();
}

class _EditPasswordViewState extends State<EditPasswordView> {
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController    = TextEditingController();
  final _newPasswordController    = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _oldPasswordVisible     = false;
  bool _newPasswordVisible     = false;
  bool _confirmPasswordVisible = false;

  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _isSuccess = false;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isLoading = false;
      _isSuccess = true;
    });

    Get.snackbar(
      'Berhasil',
      'Kata sandi berhasil diperbarui.',
      backgroundColor: _C.surfaceContLow,
      colorText: _C.primary,
      icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF95D4AC)),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
    );

    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) setState(() => _isSuccess = false);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenH = mq.size.height;
    final bottomPad = mq.padding.bottom + 24.0;
    final topPad = screenH < 680 ? 12.0 : (screenH < 780 ? 20.0 : 28.0);

    return Scaffold(
      backgroundColor: _C.background,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Top App Bar ───
            _buildAppBar(),

            // ─── Scrollable Content ───
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20, topPad, 20, bottomPad),
                child: Column(
                  children: [
                    // ─── Ilustrasi Lock ───
                    _buildIllustration(screenH),
                    SizedBox(height: screenH < 680 ? 16 : 24),

                    // ─── Form Card ───
                    _buildFormCard(),
                    const SizedBox(height: 16),

                    // ─── Footer Banner ───
                    _buildFooterBanner(screenH),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Top App Bar ────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      color: _C.surface,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          // Tombol Kembali
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: _C.onSurfaceVariant,
              size: 20,
            ),
          ),
          const Expanded(
            child: Text(
              'Ubah Kata Sandi',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _C.primary,
              ),
            ),
          ),
          // Spacer untuk centering
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // ─── Ilustrasi Lock ──────────────────────────────────────────────────────────
  Widget _buildIllustration(double screenH) {
    final circleSize = screenH < 680 ? 72.0 : (screenH < 780 ? 80.0 : 88.0);
    final iconSize   = circleSize * 0.44;
    final badgeSize  = circleSize * 0.32;
    final badgeIcon  = badgeSize * 0.55;
    return Stack(
      alignment: Alignment.center,
      children: [
        // Lingkaran utama
        Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            color: _C.primaryContainer.withValues(alpha: 0.20),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.lock_reset_rounded,
            color: _C.primary,
            size: iconSize,
          ),
        ),
        // Badge shield kecil di pojok kanan bawah
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: badgeSize,
            height: badgeSize,
            decoration: BoxDecoration(
              color: _C.surfaceContHighest,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.30),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.shield_rounded,
              color: _C.secondary,
              size: badgeIcon,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Form Card ───────────────────────────────────────────────────────────────
  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _C.surfaceContLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _C.outlineVariant.withValues(alpha: 0.50),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header Teks ───
            const Text(
              'Amankan Akun Anda',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _C.primary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Perbarui kata sandi Anda secara berkala untuk menjaga keamanan data finansial Anda di Finara.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: _C.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            // ─── Password Lama ───
            _buildLabel('PASSWORD LAMA'),
            const SizedBox(height: 6),
            _buildPasswordField(
              controller: _oldPasswordController,
              hint: 'Masukkan password saat ini',
              prefixIcon: Icons.key_rounded,
              isVisible: _oldPasswordVisible,
              onToggleVisibility: () =>
                  setState(() => _oldPasswordVisible = !_oldPasswordVisible),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Password lama tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // ─── Password Baru ───
            _buildLabel('PASSWORD BARU'),
            const SizedBox(height: 6),
            _buildPasswordField(
              controller: _newPasswordController,
              hint: 'Masukkan password baru',
              prefixIcon: Icons.lock_rounded,
              isVisible: _newPasswordVisible,
              onToggleVisibility: () =>
                  setState(() => _newPasswordVisible = !_newPasswordVisible),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Password baru tidak boleh kosong';
                }
                if (val.length < 8) {
                  return 'Minimal 8 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // ─── Konfirmasi Password ───
            _buildLabel('KONFIRMASI PASSWORD BARU'),
            const SizedBox(height: 6),
            _buildPasswordField(
              controller: _confirmPasswordController,
              hint: 'Ulangi password baru',
              prefixIcon: Icons.verified_user_rounded,
              isVisible: _confirmPasswordVisible,
              onToggleVisibility: () => setState(
                () => _confirmPasswordVisible = !_confirmPasswordVisible,
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Konfirmasi password tidak boleh kosong';
                }
                if (val != _newPasswordController.text) {
                  return 'Password tidak cocok';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // ─── Info Note ───
            _buildInfoNote(),
            const SizedBox(height: 12),

            // ─── Submit Button ───
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // ─── Label ───────────────────────────────────────────────────────────────────
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: _C.onSurfaceVariant,
        letterSpacing: 1.2,
      ),
    );
  }

  // ─── Password Field ──────────────────────────────────────────────────────────
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: _C.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: _C.onSurfaceVariant.withValues(alpha: 0.50),
        ),
        filled: true,
        fillColor: _C.surfaceContHighest.withValues(alpha: 0.50),
        prefixIcon: Icon(prefixIcon, color: _C.outline, size: 18),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: _C.outline,
            size: 18,
          ),
          onPressed: onToggleVisibility,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: _C.outlineVariant,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: _C.outlineVariant,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: _C.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _C.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _C.error, width: 1.5),
        ),
        errorStyle: const TextStyle(color: _C.error, fontSize: 11),
      ),
    );
  }

  // ─── Info Note ───────────────────────────────────────────────────────────────
  Widget _buildInfoNote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _C.primaryContainer.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _C.primary.withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: _C.primary, size: 16),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Minimal 8 karakter, kombinasi huruf dan angka.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: _C.onPrimaryContainer,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Submit Button ───────────────────────────────────────────────────────────
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isSuccess ? _C.success : _C.primary,
            foregroundColor: _C.onPrimary,
            disabledBackgroundColor: _C.primaryContainer.withValues(alpha: 0.40),
            disabledForegroundColor: _C.onPrimaryContainer.withValues(alpha: 0.60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _C.onPrimary,
                  ),
                )
              : _isSuccess
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline_rounded, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Berhasil Diperbarui',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      'Simpan Password',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
        ),
      ),
    );
  }

  // ─── Footer Banner ───────────────────────────────────────────────────────────
  Widget _buildFooterBanner(double screenH) {
    final bannerH = screenH < 680 ? 90.0 : (screenH < 780 ? 110.0 : 130.0);
    return Container(
      height: bannerH,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _C.outlineVariant.withValues(alpha: 0.30),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _C.surfaceContLow.withValues(alpha: 0.40),
            _C.background,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Dekoratif circle kanan atas
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _C.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Dekoratif circle kiri bawah
          Positioned(
            bottom: -14,
            left: -10,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _C.primary.withValues(alpha: 0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Konten teks
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    color: _C.onSurface.withValues(alpha: 0.30),
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '"Keamanan Anda adalah prioritas utama kami."',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      color: _C.onSurface.withValues(alpha: 0.80),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
