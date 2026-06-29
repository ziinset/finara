import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../data/models/catatan_model.dart';
import '../../controllers/catatan_controller.dart';

/// Bottom sheet form untuk edit catatan (pre-filled)
class CatatanEditSheet extends StatefulWidget {
  final CatatanModel catatan;

  const CatatanEditSheet({super.key, required this.catatan});

  static void show(BuildContext context, CatatanModel catatan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CatatanEditSheet(catatan: catatan),
    );
  }

  @override
  State<CatatanEditSheet> createState() => _CatatanEditSheetState();
}

class _CatatanEditSheetState extends State<CatatanEditSheet> {
  late TipeCatatan _tipe;
  late String _kategori;
  late TextEditingController _namaCtrl;
  late TextEditingController _nominalCtrl;
  late TextEditingController _catatanCtrl;
  late DateTime _tanggal;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tipe = widget.catatan.tipe;
    _kategori = widget.catatan.kategori;
    _namaCtrl = TextEditingController(text: widget.catatan.nama);
    _nominalCtrl = TextEditingController(text: widget.catatan.nominal.toInt().toString());
    _catatanCtrl = TextEditingController(text: widget.catatan.catatan ?? '');
    _tanggal = widget.catatan.tanggal;
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _nominalCtrl.dispose();
    _catatanCtrl.dispose();
    super.dispose();
  }

  List<KategoriItem> get _availableKategori =>
      _tipe == TipeCatatan.pengeluaran ? kategoriPengeluaran : kategoriPemasukan;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Drag Handle ──
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

            // ── Header ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  const Text(
                    'Edit Catatan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, size: 18, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ── Form Content ──
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Tipe Toggle ──
                    _buildSectionLabel('Tipe Catatan'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTipeButton(
                            label: 'Pengeluaran',
                            icon: Icons.arrow_downward,
                            color: const Color(0xFFE53935),
                            isSelected: _tipe == TipeCatatan.pengeluaran,
                            onTap: () {
                              setState(() {
                                _tipe = TipeCatatan.pengeluaran;
                                if (!kategoriPengeluaran.any((k) => k.nama == _kategori)) {
                                  _kategori = kategoriPengeluaran.first.nama;
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTipeButton(
                            label: 'Pemasukan',
                            icon: Icons.arrow_upward,
                            color: const Color(0xFF4CAF50),
                            isSelected: _tipe == TipeCatatan.pemasukan,
                            onTap: () {
                              setState(() {
                                _tipe = TipeCatatan.pemasukan;
                                if (!kategoriPemasukan.any((k) => k.nama == _kategori)) {
                                  _kategori = kategoriPemasukan.first.nama;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Kategori Grid ──
                    _buildSectionLabel('Kategori'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableKategori.map((kat) {
                        final isSelected = _kategori == kat.nama;
                        return GestureDetector(
                          onTap: () => setState(() => _kategori = kat.nama),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? kat.color.withValues(alpha: 0.15)
                                  : Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? kat.color : Colors.grey[300]!,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(kat.icon, size: 16, color: isSelected ? kat.color : Colors.grey[500]),
                                const SizedBox(width: 6),
                                Text(
                                  kat.nama,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    color: isSelected ? kat.color : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // ── Nominal ──
                    _buildSectionLabel('Nominal (Rp)'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _nominalCtrl,
                      hint: 'Masukkan nominal',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Nominal tidak boleh kosong';
                        if (int.tryParse(val) == null || int.parse(val) <= 0) {
                          return 'Nominal harus lebih dari 0';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // ── Nama Catatan ──
                    _buildSectionLabel('Nama Catatan'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _namaCtrl,
                      hint: 'Contoh: Makan siang',
                      maxLength: 100,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Nama catatan tidak boleh kosong';
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // ── Notes ──
                    _buildSectionLabel('Catatan / Notes (opsional)'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _catatanCtrl,
                      hint: 'Tulis catatan tambahan...',
                      maxLines: 3,
                      maxLength: 500,
                    ),

                    const SizedBox(height: 20),

                    // ── Tanggal & Waktu ──
                    _buildSectionLabel('Tanggal & Waktu'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _tanggal,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          builder: (ctx, child) => Theme(
                            data: Theme.of(ctx).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF3A6043),
                              ),
                            ),
                            child: child!,
                          ),
                        );
                        if (date != null && context.mounted) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_tanggal),
                            builder: (ctx, child) => Theme(
                              data: Theme.of(ctx).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF3A6043),
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          setState(() {
                            _tanggal = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time?.hour ?? _tanggal.hour,
                              time?.minute ?? _tanggal.minute,
                            );
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6F0),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey[500]),
                            const SizedBox(width: 10),
                            Text(
                              '${_tanggal.day}/${_tanggal.month}/${_tanggal.year}  ${_tanggal.hour.toString().padLeft(2, '0')}:${_tanggal.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF2D2D2D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ── Save Button ──
            Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                8,
                24,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A6043),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final updated = widget.catatan.copyWith(
      nama: _namaCtrl.text.trim(),
      tipe: _tipe,
      kategori: _kategori,
      nominal: double.parse(_nominalCtrl.text),
      tanggal: _tanggal,
      catatan: _catatanCtrl.text.trim().isEmpty ? null : _catatanCtrl.text.trim(),
    );

    Get.find<CatatanController>().updateCatatan(updated);
    Get.back(); // close edit sheet
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF444444),
      ),
    );
  }

  Widget _buildTipeButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : Colors.grey[50],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? color : Colors.grey[400]),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF2D2D2D),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey[400],
        ),
        filled: true,
        fillColor: const Color(0xFFF5F6F0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF3A6043), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE53935)),
        ),
        counterStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
