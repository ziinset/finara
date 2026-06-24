import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/catatan_model.dart';
import '../../controllers/catatan_controller.dart';

/// Bottom sheet untuk filter & sorting catatan
class CatatanFilterSheet extends StatelessWidget {
  const CatatanFilterSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CatatanFilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CatatanController>();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
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
                  'Filter & Urutkan',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    controller.resetAllFilters();
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ── Content ──
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Sort Section ──
                  _buildSectionTitle('Urutkan'),
                  const SizedBox(height: 10),
                  Obx(() => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: SortType.values.map((type) {
                          final isSelected = controller.selectedSortType.value == type;
                          return _buildSortChip(
                            label: _sortLabel(type),
                            isSelected: isSelected,
                            onTap: () => controller.setSortType(type),
                          );
                        }).toList(),
                      )),

                  const SizedBox(height: 24),

                  // ── Kategori Section ──
                  _buildSectionTitle('Kategori'),
                  const SizedBox(height: 10),
                  Obx(() {
                    final allKats = <String>{};
                    for (final k in kategoriPengeluaran) {
                      allKats.add(k.nama);
                    }
                    for (final k in kategoriPemasukan) {
                      allKats.add(k.nama);
                    }

                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: allKats.map((kat) {
                        final isSelected = controller.selectedKategoriFilter.contains(kat);
                        final item = kategoriPengeluaran.cast<KategoriItem?>().firstWhere(
                              (k) => k?.nama == kat,
                              orElse: () => kategoriPemasukan.cast<KategoriItem?>().firstWhere(
                                    (k) => k?.nama == kat,
                                    orElse: () => null,
                                  ),
                            );

                        return _buildKategoriChip(
                          label: kat,
                          icon: item?.icon ?? Icons.more_horiz,
                          color: item?.color ?? Colors.grey,
                          isSelected: isSelected,
                          onTap: () => controller.toggleKategoriFilter(kat),
                        );
                      }).toList(),
                    );
                  }),

                  const SizedBox(height: 24),

                  // ── Rentang Tanggal ──
                  _buildSectionTitle('Rentang Tanggal'),
                  const SizedBox(height: 10),
                  Obx(() => Row(
                        children: [
                          Expanded(
                            child: _buildDateButton(
                              context: context,
                              label: controller.dateRangeStart.value != null
                                  ? '${controller.dateRangeStart.value!.day}/${controller.dateRangeStart.value!.month}/${controller.dateRangeStart.value!.year}'
                                  : 'Dari',
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: controller.dateRangeStart.value ?? DateTime.now(),
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
                                if (date != null) {
                                  controller.setDateRange(date, controller.dateRangeEnd.value);
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.arrow_forward, size: 18, color: Colors.grey[400]),
                          ),
                          Expanded(
                            child: _buildDateButton(
                              context: context,
                              label: controller.dateRangeEnd.value != null
                                  ? '${controller.dateRangeEnd.value!.day}/${controller.dateRangeEnd.value!.month}/${controller.dateRangeEnd.value!.year}'
                                  : 'Sampai',
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: controller.dateRangeEnd.value ?? DateTime.now(),
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
                                if (date != null) {
                                  controller.setDateRange(controller.dateRangeStart.value, date);
                                }
                              },
                            ),
                          ),
                        ],
                      )),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ── Apply Button ──
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
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A6043),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Terapkan Filter',
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF444444),
      ),
    );
  }

  Widget _buildSortChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3A6043) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF3A6043) : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  Widget _buildKategoriChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? color : Colors.grey[500]),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? color : const Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey[500]),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: label == 'Dari' || label == 'Sampai'
                      ? Colors.grey[400]
                      : const Color(0xFF2D2D2D),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _sortLabel(SortType type) {
    switch (type) {
      case SortType.terbaru:
        return 'Terbaru';
      case SortType.terlama:
        return 'Terlama';
      case SortType.nominalTerbesar:
        return 'Nominal ↑';
      case SortType.nominalTerkecil:
        return 'Nominal ↓';
    }
  }
}
