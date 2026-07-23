import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─── Color Palette — Terra Finance Dark (Deep Forest) ─────────────────────────
// Sesuai DESIGN.md & code.html stitch_user_edit_profile_dark_mode
class _C {
  _C._();

  // Background & Surfaces
  static const Color background         = Color(0xFF101411);
  static const Color surfaceCont        = Color(0xFF1D211D); // surface-container
  static const Color surfaceContHighest = Color(0xFF313631); // surface-container-highest

  // Primary
  static const Color primary            = Color(0xFFB1CEB5); // illuminated forest green
  static const Color primaryContainer   = Color(0xFF3D5643); // primary-container
  static const Color onPrimaryContainer = Color(0xFFAECAB2); // on-primary-container

  // Secondary (gold accent)
  static const Color secondary          = Color(0xFFE3C53C);
  static const Color onSecondary        = Color(0xFF362F00);

  // On-Surface (text)
  static const Color onSurfaceVariant  = Color(0xFFC2C8C0);

  // Outline
  static const Color outlineVariant    = Color(0xFF424843);

  // Error
  static const Color error             = Color(0xFFFFB4AB);

  // Card background (matches HTML inline style)
  static const Color cardBg            = Color(0xFF1F1F1F);
}

class ProfilSayaView extends StatefulWidget {
  const ProfilSayaView({super.key});

  @override
  State<ProfilSayaView> createState() => _ProfilSayaViewState();
}

class _ProfilSayaViewState extends State<ProfilSayaView> {
  final _formKey = GlobalKey<FormState>();
  final _namaController       = TextEditingController(text: 'Goldi Arasseo');
  final _usernameController   = TextEditingController(text: 'goldiarasseo');
  final _emailController      = TextEditingController(text: 'goldi.arasseo@terra.com');
  final _teleponController    = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() => _isLoading = false);

    Get.snackbar(
      'Berhasil',
      'Profil berhasil diperbarui.',
      backgroundColor: _C.surfaceCont,
      colorText: _C.primary,
      icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF95D4AC)),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final bottomPad = mq.padding.bottom + 24.0;

    return Scaffold(
      backgroundColor: _C.background,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Top Navigation Bar ───
            _buildAppBar(),

            // ─── Scrollable Content ───
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: bottomPad,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ─── Foto Profil Section ───
                      _buildPhotoSection(),

                      // ─── Card Informasi Profil ───
                      _buildInfoCard(),
                      const SizedBox(height: 16),

                      // ─── Tombol Simpan ───
                      _buildSaveButton(),
                    ],
                  ),
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
      color: _C.background,
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
              'Edit Profil',
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

  // ─── Foto Profil Section ─────────────────────────────────────────────────────
  Widget _buildPhotoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar + camera button
          Stack(
            children: [
              // Avatar circle
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _C.surfaceContHighest,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.40),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/img/Profile-Picture.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: _C.surfaceCont,
                      child: const Icon(
                        Icons.person_rounded,
                        size: 38,
                        color: _C.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),

              // Tombol Kamera
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Get.snackbar(
                      'Ubah Foto',
                      'Fitur ubah foto profil akan segera hadir.',
                      backgroundColor: _C.surfaceCont,
                      colorText: _C.primary,
                    );
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _C.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _C.surfaceContHighest,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.photo_camera_rounded,
                      size: 14,
                      color: _C.onSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Nama Pengguna
          Text(
            'Goldi Arasseo',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: _C.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Card Informasi Profil ───────────────────────────────────────────────────
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _C.outlineVariant.withValues(alpha: 0.30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Row(
            children: [
              const Icon(
                Icons.person_outline_rounded,
                color: _C.primary,
                size: 16,
              ),
              const SizedBox(width: 6),
              const Text(
                'INFORMASI PROFIL',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _C.onSurfaceVariant,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Nama Lengkap
          _buildInputField(
            label: 'Nama Lengkap',
            controller: _namaController,
            validator: (val) =>
                (val == null || val.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
          ),
          const SizedBox(height: 12),

          // Nama Pengguna
          _buildInputField(
            label: 'Nama Pengguna',
            controller: _usernameController,
            prefixText: '@',
            validator: (val) =>
                (val == null || val.trim().isEmpty) ? 'Username tidak boleh kosong' : null,
          ),
          const SizedBox(height: 12),

          // Alamat Email
          _buildInputField(
            label: 'Alamat Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Email tidak boleh kosong';
              if (!val.contains('@')) return 'Format email tidak valid';
              return null;
            },
          ),
          const SizedBox(height: 12),

          // Nomor Telepon (Opsional)
          _buildInputField(
            label: 'Nomor Telepon (Opsional)',
            controller: _teleponController,
            keyboardType: TextInputType.phone,
            hintText: '+62 812 3456 7890',
          ),
          const SizedBox(height: 12),

          // Tanggal Bergabung (Read-only)
          _buildReadonlyField(
            label: 'Tanggal Bergabung',
            value: '12 Oktober 2023',
          ),
        ],
      ),
    );
  }

  // ─── Input Field ─────────────────────────────────────────────────────────────
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? prefixText,
    String? hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _C.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: _C.onSurfaceVariant,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: _C.surfaceContHighest,
            prefixText: prefixText,
            prefixStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: _C.onSurfaceVariant,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: _C.onSurfaceVariant.withValues(alpha: 0.50),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: _C.outlineVariant.withValues(alpha: 0.30),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: _C.outlineVariant.withValues(alpha: 0.30),
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
        ),
      ],
    );
  }

  // ─── Read-only Field ─────────────────────────────────────────────────────────
  Widget _buildReadonlyField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _C.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _C.surfaceContHighest,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _C.outlineVariant.withValues(alpha: 0.30),
              width: 1,
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: _C.onSurfaceVariant.withValues(alpha: 0.60),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Tombol Simpan ───────────────────────────────────────────────────────────
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: _C.primaryContainer,
          foregroundColor: _C.onPrimaryContainer,
          disabledBackgroundColor: _C.primaryContainer.withValues(alpha: 0.40),
          disabledForegroundColor: _C.onPrimaryContainer.withValues(alpha: 0.50),
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
                  color: _C.onPrimaryContainer,
                ),
              )
            : const Text(
                'Simpan Perubahan',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
