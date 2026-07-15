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
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
                child: Column(
                  children: [
                    // ─── Ilustrasi Lock ───
                    _buildIllustration(),
                    const SizedBox(height: 32),

                    // ─── Form Card ───
                    _buildFormCard(),
                    const SizedBox(height: 24),

                    // ─── Footer Banner ───
                    _buildFooterBanner(),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tombol Kembali
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: _C.onSurface,
                size: 24,
              ),
            ),
          ),

          // Title
          const Text(
            'Ubah Kata Sandi',
            style: TextStyle(
              fontFamily: 'HankenGrotesk',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _C.primary,
            ),
          ),

          // Spacer untuk centering
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  // ─── Ilustrasi Lock ──────────────────────────────────────────────────────────
  Widget _buildIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Lingkaran utama
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            // primary-container/20 — sesuai HTML: bg-primary-container/20
            color: _C.primaryContainer.withValues(alpha: 0.20),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_reset_rounded,
            color: _C.primary,
            size: 56,
          ),
        ),

        // Badge shield kecil di pojok kanan bawah
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _C.surfaceContHighest,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.40),
                  blurRadius: 24,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: _C.secondary,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Form Card ───────────────────────────────────────────────────────────────
  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        // surface-container-low
        color: _C.surfaceContLow,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: _C.outlineVariant.withValues(alpha: 0.50),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.40),
            blurRadius: 24,
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
                fontFamily: 'HankenGrotesk',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: _C.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Perbarui kata sandi Anda secara berkala untuk menjaga keamanan data finansial Anda di Finara.',
              style: TextStyle(
                fontFamily: 'HankenGrotesk',
                fontSize: 14,
                color: _C.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // ─── Password Lama ───
            _buildLabel('PASSWORD LAMA'),
            const SizedBox(height: 8),
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
            const SizedBox(height: 24),

            // ─── Password Baru ───
            _buildLabel('PASSWORD BARU'),
            const SizedBox(height: 8),
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
            const SizedBox(height: 24),

            // ─── Konfirmasi Password ───
            _buildLabel('KONFIRMASI PASSWORD BARU'),
            const SizedBox(height: 8),
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
            const SizedBox(height: 24),

            // ─── Info Note ───
            _buildInfoNote(),
            const SizedBox(height: 16),

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
        fontFamily: 'HankenGrotesk',
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
        fontFamily: 'HankenGrotesk',
        fontSize: 16,
        color: _C.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'HankenGrotesk',
          fontSize: 16,
          color: _C.onSurfaceVariant.withValues(alpha: 0.50),
        ),
        filled: true,
        // surface-container-highest/50 — sesuai HTML
        fillColor: _C.surfaceContHighest.withValues(alpha: 0.50),
        prefixIcon: Icon(prefixIcon, color: _C.outline, size: 22),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: _C.outline,
            size: 22,
          ),
          onPressed: onToggleVisibility,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: _C.outlineVariant,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: _C.outlineVariant,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: _C.primary, // forest green focus
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _C.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _C.error, width: 1.5),
        ),
        errorStyle: const TextStyle(color: _C.error),
      ),
    );
  }

  // ─── Info Note ───────────────────────────────────────────────────────────────
  Widget _buildInfoNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // primary-container/20 + border primary/10
        color: _C.primaryContainer.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _C.primary.withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: _C.primary, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Minimal 8 karakter, kombinasi huruf dan angka.',
              style: TextStyle(
                fontFamily: 'HankenGrotesk',
                fontSize: 14,
                color: _C.onPrimaryContainer,
                height: 1.5,
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isSuccess ? _C.success : _C.primary,
            foregroundColor: _C.onPrimary,
            disabledBackgroundColor: _C.primaryContainer.withValues(alpha: 0.40),
            disabledForegroundColor: _C.onPrimaryContainer.withValues(alpha: 0.60),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            shadowColor: Colors.black.withValues(alpha: 0.40),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: _C.onPrimary,
                  ),
                )
              : _isSuccess
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline_rounded, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Berhasil Diperbarui',
                          style: TextStyle(
                            fontFamily: 'HankenGrotesk',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      'Simpan Password',
                      style: TextStyle(
                        fontFamily: 'HankenGrotesk',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
        ),
      ),
    );
  }

  // ─── Footer Banner ───────────────────────────────────────────────────────────
  Widget _buildFooterBanner() {
    return Container(
      height: 192,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.40),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Dekoratif circle kanan atas
          Positioned(
            top: -28,
            right: -28,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: _C.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Dekoratif circle kiri bawah
          Positioned(
            bottom: -20,
            left: -14,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: _C.primary.withValues(alpha: 0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Konten teks
          Padding(
            padding: const EdgeInsets.all(24),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    color: _C.onSurface.withValues(alpha: 0.30),
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '"Keamanan Anda adalah prioritas utama kami."',
                    style: TextStyle(
                      fontFamily: 'HankenGrotesk',
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      color: _C.onSurface.withValues(alpha: 0.80),
                      height: 1.5,
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
