import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─── Color Palette — Terra Finance Dark (reuse dari profile) ─────────────────
class _C {
  _C._();
  static const Color background         = Color(0xFF101411);
  static const Color surfaceContLow     = Color(0xFF181D19);
  static const Color surfaceCont        = Color(0xFF1D211E);
  static const Color surfaceContHighest = Color(0xFF313531);
  static const Color primary            = Color(0xFFB1CEB5);
  static const Color primaryContainer   = Color(0xFF344C3A);
  static const Color onPrimary          = Color(0xFF003920);
  static const Color secondary          = Color(0xFFE3C53C);
  static const Color onSecondaryContainer = Color(0xFFFFE262);
  static const Color onSurface         = Color(0xFFE1E3DE);
  static const Color onSurfaceVariant  = Color(0xFFC2C8C0);
  static const Color outlineVariant    = Color(0xFF424843);
  static const Color error             = Color(0xFFFFB4AB);
  static const Color errorContainer    = Color(0xFF93000A);
}

enum EksporFormat { excel, pdf }

/// Panggil dengan [EksporDataModal.show(context, format: EksporFormat.excel)]
class EksporDataModal extends StatefulWidget {
  final EksporFormat format;

  const EksporDataModal({super.key, required this.format});

  static void show(BuildContext context, {required EksporFormat format}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EksporDataModal(format: format),
    );
  }

  @override
  State<EksporDataModal> createState() => _EksporDataModalState();
}

class _EksporDataModalState extends State<EksporDataModal> {
  // ── Filter State ──
  String _tglMulai   = '01 Jun 2026';
  String _tglAkhir   = '30 Jun 2026';
  String _tipe       = 'Semua Tipe';
  String _kategori   = 'Semua Kategori';

  final _tipeOptions     = ['Semua Tipe', 'Pemasukan', 'Pengeluaran'];
  final _kategoriOptions = ['Semua Kategori', 'Makanan', 'Transport', 'Kesehatan', 'Hiburan', 'Lainnya'];

  bool get _isExcel => widget.format == EksporFormat.excel;

  // ── Colors berdasarkan format ──
  Color get _accentColor  => _isExcel ? _C.primary           : _C.error;
  Color get _accentBg     => _isExcel ? _C.primaryContainer  : _C.errorContainer;
  IconData get _formatIcon => _isExcel ? Icons.description_rounded : Icons.picture_as_pdf_rounded;
  String get _formatLabel  => _isExcel ? 'Excel'  : 'PDF';
  String get _formatExt    => _isExcel ? '.xlsx'  : '.pdf';
  String get _buttonLabel  => 'Ekspor ke $_formatLabel ($_formatExt)';

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom
        + MediaQuery.of(context).padding.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: _C.surfaceCont,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _C.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Scrollable content ──
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 0, 24, bottomPadding + 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _accentBg.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _accentColor.withValues(alpha: 0.20),
                          ),
                        ),
                        child: Icon(_formatIcon, color: _accentColor, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ekspor $_formatLabel',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _C.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Format $_formatExt — sesuaikan filter lalu ekspor',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: _C.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),
                  _buildDivider(),
                  const SizedBox(height: 24),

                  // ── Rentang Tanggal ──
                  _buildSectionLabel('Rentang Tanggal'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateTile(
                          label: 'Mulai',
                          value: _tglMulai,
                          onTap: () => _pickDate(isStart: true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 20,
                        height: 1,
                        color: _C.outlineVariant,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDateTile(
                          label: 'Akhir',
                          value: _tglAkhir,
                          onTap: () => _pickDate(isStart: false),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Tipe Catatan ──
                  _buildSectionLabel('Tipe Catatan'),
                  const SizedBox(height: 10),
                  _buildSelectTile(
                    value: _tipe,
                    options: _tipeOptions,
                    onChanged: (v) => setState(() => _tipe = v),
                  ),

                  const SizedBox(height: 20),

                  // ── Kategori ──
                  _buildSectionLabel('Kategori'),
                  const SizedBox(height: 10),
                  _buildSelectTile(
                    value: _kategori,
                    options: _kategoriOptions,
                    onChanged: (v) => setState(() => _kategori = v),
                  ),

                  const SizedBox(height: 32),
                  _buildDivider(),
                  const SizedBox(height: 24),

                  // ── Ekspor Button ──
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _onEkspor,
                      icon: Icon(_formatIcon, size: 20),
                      label: Text(_buttonLabel),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentColor,
                        foregroundColor: _isExcel ? _C.onPrimary : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Batal ──
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: _C.onSurfaceVariant,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

  // ── Helpers ──

  Widget _buildDivider() => Divider(
        height: 1,
        thickness: 1,
        color: _C.outlineVariant.withValues(alpha: 0.40),
      );

  Widget _buildSectionLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _C.onSurfaceVariant,
          letterSpacing: 1.4,
        ),
      );

  Widget _buildDateTile({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: _C.surfaceContLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.outlineVariant.withValues(alpha: 0.50)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: _C.onSurfaceVariant,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _C.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: _C.onSurfaceVariant,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectTile({
    required String value,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    return GestureDetector(
      onTap: () => _showOptionPicker(options, value, onChanged),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _C.surfaceContLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.outlineVariant.withValues(alpha: 0.50)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _C.onSurface,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: _C.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionPicker(
    List<String> options,
    String current,
    ValueChanged<String> onChanged,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: _C.surfaceContLow,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _C.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...options.map((opt) {
                final isSelected = opt == current;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    opt,
                    style: TextStyle(
                      fontFamily: isSelected ? 'Poppins' : 'Inter',
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? _accentColor : _C.onSurface,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_rounded, color: _accentColor, size: 20)
                      : null,
                  onTap: () {
                    onChanged(opt);
                    Navigator.of(context).pop();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: now,
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: _C.primary,
            onPrimary: _C.onPrimary,
            surface: _C.surfaceCont,
            onSurface: _C.onSurface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    final formatted =
        '${picked.day.toString().padLeft(2, '0')} ${_monthName(picked.month)} ${picked.year}';
    setState(() {
      if (isStart) {
        _tglMulai = formatted;
      } else {
        _tglAkhir = formatted;
      }
    });
  }

  String _monthName(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ][m];

  void _onEkspor() {
    Navigator.of(context).pop();
    Get.snackbar(
      'Memproses...',
      'File $_formatLabel sedang disiapkan',
      backgroundColor: _C.surfaceContHighest,
      colorText: _C.onSurface,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 14,
      icon: Icon(_formatIcon, color: _accentColor),
    );
  }
}
