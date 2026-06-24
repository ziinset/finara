import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/catatan_model.dart';
import '../controllers/catatan_controller.dart';
import 'widgets/catatan_detail_modal.dart';
import 'widgets/catatan_filter_sheet.dart';

class CatatanView extends GetView<CatatanController> {
  const CatatanView({super.key});

  // ─── Design Tokens ───
  static const Color _bgColor = Color(0xFFEBEBE0);
  static const Color _primaryGreen = Color(0xFF3A6043);
  static const Color _incomeColor = Color(0xFF4CAF50);
  static const Color _expenseColor = Color(0xFFE53935);
  static const Color _cardBg = Colors.white;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      color: _bgColor,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Catatan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Obx(() => Text(
                              '${controller.filteredCatatan.length} catatan ditemukan',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[500],
                              ),
                            )),
                      ],
                    ),
                  ),
                  // Filter Button
                  Obx(() => GestureDetector(
                        onTap: () => CatatanFilterSheet.show(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: controller.isFilterActive
                                ? _primaryGreen.withValues(alpha: 0.12)
                                : _cardBg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: controller.isFilterActive
                                  ? _primaryGreen
                                  : Colors.grey[300]!,
                              width: controller.isFilterActive ? 1.5 : 1,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  Icons.tune_outlined,
                                  color: controller.isFilterActive
                                      ? _primaryGreen
                                      : Colors.grey[500],
                                  size: 22,
                                ),
                              ),
                              if (controller.isFilterActive)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: _primaryGreen,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Search Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.onSearchChanged,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF2D2D2D),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari catatan...',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[400],
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[400],
                      size: 22,
                    ),
                    suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                        ? GestureDetector(
                            onTap: controller.clearSearch,
                            child: Icon(
                              Icons.close,
                              color: Colors.grey[400],
                              size: 20,
                            ),
                          )
                        : const SizedBox.shrink()),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Tipe Filter Chips ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() => Row(
                    children: [
                      _buildTipeChip(
                        label: 'Semua',
                        isSelected: controller.selectedTipeFilter.value == null,
                        onTap: () => controller.setTipeFilter(null),
                      ),
                      const SizedBox(width: 8),
                      _buildTipeChip(
                        label: 'Pemasukan',
                        isSelected: controller.selectedTipeFilter.value ==
                            TipeCatatan.pemasukan,
                        onTap: () =>
                            controller.setTipeFilter(TipeCatatan.pemasukan),
                        color: _incomeColor,
                      ),
                      const SizedBox(width: 8),
                      _buildTipeChip(
                        label: 'Pengeluaran',
                        isSelected: controller.selectedTipeFilter.value ==
                            TipeCatatan.pengeluaran,
                        onTap: () =>
                            controller.setTipeFilter(TipeCatatan.pengeluaran),
                        color: _expenseColor,
                      ),
                    ],
                  )),
            ),

            const SizedBox(height: 16),

            // ── Main Content: Catatan List ──
            Expanded(
              child: Obx(() {
                if (controller.filteredCatatan.isEmpty) {
                  return _buildEmptyState();
                }

                final dateKeys = controller.sortedDateKeys;

                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    MediaQuery.of(context).padding.bottom + 100,
                  ),
                  itemCount: _calculateItemCount(dateKeys),
                  itemBuilder: (context, index) {
                    int currentIndex = 0;

                    // ── Analysis Card at the top ──
                    if (index == 0) {
                      return _buildAnalysisCard();
                    }
                    currentIndex = 1;

                    for (final dateKey in dateKeys) {
                      final items = controller.groupedCatatan[dateKey]!;

                      // Date header
                      if (index == currentIndex) {
                        return _buildDateHeader(dateKey);
                      }
                      currentIndex++;

                      // Catatan items
                      for (int i = 0; i < items.length; i++) {
                        if (index == currentIndex) {
                          return _buildCatatanItem(
                            context,
                            items[i],
                            currencyFormat,
                            isLast: i == items.length - 1,
                          );
                        }
                        currentIndex++;
                      }
                    }

                    return const SizedBox.shrink();
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateItemCount(List<DateTime> dateKeys) {
    int count = 1; // analysis card
    for (final key in dateKeys) {
      count += 1; // date header
      count += controller.groupedCatatan[key]!.length;
    }
    return count;
  }

  // ─── Analysis Card (like the reference image) ───
  Widget _buildAnalysisCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3A6043),
            Color(0xFF2E4A34),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _primaryGreen.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ── Chart graphic decoration (right side) ──
          Positioned(
            right: -8,
            top: -8,
            bottom: -8,
            child: Opacity(
              opacity: 0.15,
              child: const Icon(
                Icons.show_chart,
                size: 120,
                color: Colors.white,
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD54F),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'ANALISIS MINGGU INI',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: Color(0xFFFFD54F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Main text
              const Text(
                'Pengeluaran Anda turun 12%',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 14),

              // CTA Button
              GestureDetector(
                onTap: () {
                  // Navigate to statistik/chart
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Lihat Laporan Lengkap',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Date Header ───
  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateDay = DateTime(date.year, date.month, date.day);

    String label;
    if (dateDay == today) {
      label = 'Hari ini, ${DateFormat('d MMMM yyyy', 'id_ID').format(date)}';
    } else if (dateDay == yesterday) {
      label = 'Kemarin, ${DateFormat('d MMMM yyyy', 'id_ID').format(date)}';
    } else {
      label = DateFormat('d MMMM yyyy', 'id_ID').format(date);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  // ─── Catatan Item Card ───
  Widget _buildCatatanItem(
    BuildContext context,
    CatatanModel catatan,
    NumberFormat currencyFormat, {
    bool isLast = false,
  }) {
    final timeFormat = DateFormat('HH:mm', 'id_ID');

    return GestureDetector(
      onTap: () => CatatanDetailModal.show(context, catatan),
      child: Container(
        margin: EdgeInsets.only(bottom: isLast ? 16 : 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Category Icon ──
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: catatan.kategoriColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                catatan.kategoriIcon,
                color: catatan.kategoriColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // ── Title + Subtitle ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    catatan.nama,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D2D2D),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${catatan.kategori} · ${timeFormat.format(catatan.tanggal)}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            // ── Nominal ──
            Text(
              '${catatan.nominalPrefix} ${currencyFormat.format(catatan.nominal)}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: catatan.tipeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Tipe Filter Chip ───
  Widget _buildTipeChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    final chipColor = color ?? _primaryGreen;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor.withValues(alpha: 0.12) : _cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? chipColor : Colors.grey[300]!,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? chipColor : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  // ─── Empty State ───
  Widget _buildEmptyState() {
    final isSearchActive = controller.searchQuery.value.isNotEmpty ||
        controller.isFilterActive;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration circle
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _primaryGreen.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSearchActive ? Icons.search_off : Icons.sticky_note_2_outlined,
                size: 48,
                color: _primaryGreen.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isSearchActive
                  ? 'Catatan tidak ditemukan'
                  : 'Belum ada catatan',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearchActive
                  ? 'Coba ubah kata kunci atau filter yang digunakan.'
                  : 'Mulai catat keuanganmu sekarang!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.grey[500],
                height: 1.5,
              ),
            ),
            if (!isSearchActive) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to create catatan
                },
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Tambah Catatan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            if (isSearchActive) ...[
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  controller.clearSearch();
                  controller.resetAllFilters();
                },
                child: const Text(
                  'Reset Semua Filter',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _primaryGreen,
                  ),
                ),
              ),
            ],
            // Spacing to account for bottom nav
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
