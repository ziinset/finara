import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/catatan_model.dart';
import '../../controllers/catatan_controller.dart';
import 'catatan_edit_sheet.dart';

/// Modal bottom sheet yang menampilkan detail catatan
class CatatanDetailModal extends StatelessWidget {
  final CatatanModel catatan;

  const CatatanDetailModal({super.key, required this.catatan});

  static void show(BuildContext context, CatatanModel catatan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CatatanDetailModal(catatan: catatan),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('d MMMM yyyy', 'id_ID');
    final timeFormat = DateFormat('HH:mm', 'id_ID');

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            8,
            24,
            MediaQuery.of(context).padding.bottom + 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Drag Handle ──
              Center(
                child: Container(
                  width: 60,
                  height: 6,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),

              // ── Header: Judul + Badge tengah (tanpa icon) ──
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      catatan.nama,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D2D2D),
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: catatan.tipeColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      catatan.tipeLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: catatan.tipeColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Nominal ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA), // abu abu pastel
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Lingkaran gradasi: terang di atas → gelap di bawah
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: catatan.tipe == TipeCatatan.pengeluaran
                              ? [
                                  const Color(0xFFFFEBEE), // terang atas
                                  const Color(0xFFFFCDD2), // gelap bawah
                                ]
                              : [
                                  const Color(0xFFE8F5E9), // terang atas
                                  const Color(0xFFC8E6C9), // gelap bawah
                                ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: catatan.tipe == TipeCatatan.pengeluaran
                                ? [
                                    const Color(0xFFEF9A9A), // terang atas
                                    const Color(0xFFC62828), // gelap bawah
                                  ]
                                : [
                                    const Color(0xFF81C784), // terang atas
                                    const Color(0xFF2E7D32), // gelap bawah
                                  ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ).createShader(bounds),
                          blendMode: BlendMode.srcIn,
                          child: Icon(
                            catatan.tipe == TipeCatatan.pengeluaran
                                ? Icons.arrow_downward_rounded
                                : Icons.arrow_upward_rounded,
                            size: 26,
                            color: Colors.white, // diperlukan agar ShaderMask bekerja
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nominal',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${catatan.nominalPrefix} ${currencyFormat.format(catatan.nominal)}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Judul section detail ──
              const Text(
                'Detail Catatan',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 8),

              // ── Detail fields (tanpa icon) ──
              _buildDetailRow(
                label: 'Kategori',
                value: catatan.kategori,
              ),
              _buildDetailRow(
                label: 'Tanggal',
                value: dateFormat.format(catatan.tanggal),
              ),
              _buildDetailRow(
                label: 'Waktu',
                value: timeFormat.format(catatan.tanggal),
              ),

              // ── Catatan / Notes (tanpa icon) ──
              if (catatan.catatan != null && catatan.catatan!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Catatan',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF888888),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        catatan.catatan!,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF444444),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 28),

              // ── Action Buttons ──
              Row(
                children: [
                  // Edit button (besar, kiri)
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.back(); // close detail
                          CatatanEditSheet.show(context, catatan);
                        },
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        label: const Text('Edit Catatan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3A6043),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Hapus button (kotak icon-only, kanan)
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => _showDeleteConfirmation(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE53935),
                        padding: EdgeInsets.zero,
                        side: const BorderSide(
                          color: Color(0xFFE53935),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Icon(Icons.delete_outline, size: 22),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Label (kiri)
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF9E9E9E),
              ),
            ),
          ),
          // Value (kanan)
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D2D2D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Hapus Catatan?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Yakin ingin menghapus catatan ini? Tindakan ini tidak dapat dibatalkan.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF666666),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Color(0xFF888888),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // close dialog
              Get.find<CatatanController>().deleteCatatan(catatan.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
