import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/catatan_model.dart';
import '../controllers/catatan_controller.dart';
import 'widgets/catatan_detail_modal.dart';
import 'widgets/catatan_filter_sheet.dart';

// ─── Dark Mode Color Palette (Deep Forest) ────────────────────────────────────
class _DC {
  _DC._();

  // Surfaces
  static const Color surface = Color(0xFF101411);
  static const Color surfaceContainerLow = Color(0xFF181D19);
  static const Color surfaceContainer = Color(0xFF1C211D);
  static const Color surfaceContainerHigh = Color(0xFF272B28);

  // Text
  static const Color onSurface = Color(0xFFE0E3DE);
  static const Color onSurfaceVariant = Color(0xFFC0C9C0);

  // Brand
  static const Color primary = Color(0xFF95D4AC);
  static const Color onPrimary = Color(0xFF003920);

  // Secondary
  static const Color secondary = Color(0xFFC1C8C3);

  // Borders
  static const Color outline = Color(0xFF8A938B);
  static const Color outlineVariant = Color(0xFF404942);

  // Semantic
  static const Color error = Color(0xFFFFB4AB);

  // Utility
  static const Color white5 = Color(0x0DFFFFFF);
}

class CatatanView extends GetView<CatatanController> {
  const CatatanView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      color: _DC.surface,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top App Bar ──
            _buildTopAppBar(context),

            // ── Search Bar ──
            const SizedBox(height: 16),
            _buildSearchBar(),

            // ── Filter Chips ──
            const SizedBox(height: 12),
            _buildFilterChips(),

            const SizedBox(height: 20),

            // ── Main Content ──
            Expanded(
              child: Obx(() {
                if (controller.filteredCatatan.isEmpty) {
                  return _buildEmptyState();
                }

                final dateKeys = controller.sortedDateKeys;

                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    MediaQuery.of(context).padding.bottom + 120,
                  ),
                  itemCount: _calculateItemCount(dateKeys),
                  itemBuilder: (context, index) {
                    int currentIndex = 0;

                    // ── Insight Image Banner at top ──
                    if (index == 0) {
                      return _buildInsightBanner();
                    }
                    currentIndex = 1;

                    for (final dateKey in dateKeys) {
                      final items = controller.groupedCatatan[dateKey]!;
                      final int limit =
                          items.length > 3 ? 3 : items.length;

                      // Date header
                      if (index == currentIndex) {
                        return _buildDateHeader(
                            context, dateKey, items, currencyFormat);
                      }
                      currentIndex++;

                      // Max 3 item per hari di halaman utama
                      for (int i = 0; i < limit; i++) {
                        if (index == currentIndex) {
                          return _DarkCatatanCard(
                            catatan: items[i],
                            currencyFormat: currencyFormat,
                            isLast: i == limit - 1,
                            onTap: () =>
                                CatatanDetailModal.show(context, items[i]),
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
    int count = 1; // insight image banner
    for (final key in dateKeys) {
      count += 1; // date header
      final items = controller.groupedCatatan[key]!;
      count += items.length > 3 ? 3 : items.length; // max 3 item per hari
    }
    return count;
  }

  // ─── Top App Bar ─────────────────────────────────────────────────────────────
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      color: _DC.surface.withValues(alpha: 0.9),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + count
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
                    color: _DC.primary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Obx(() => Text(
                      '${controller.filteredCatatan.length} catatan ditemukan',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _DC.onSurfaceVariant,
                        letterSpacing: 0.3,
                      ),
                    )),
              ],
            ),
          ),

          // Action Buttons
          Row(
            children: [
              _buildIconButton(
                icon: Icons.search,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              Obx(() => _buildIconButton(
                    icon: Icons.tune_outlined,
                    onTap: () => CatatanFilterSheet.show(context),
                    isActive: controller.isFilterActive,
                    showDot: controller.isFilterActive,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
    bool showDot = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isActive
                  ? _DC.primary.withValues(alpha: 0.15)
                  : _DC.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive ? _DC.primary.withValues(alpha: 0.4) : _DC.white5,
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? _DC.primary : _DC.onSurfaceVariant,
              size: 20,
            ),
          ),
          if (showDot)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: _DC.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Search Bar ──────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: _DC.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _DC.outlineVariant.withValues(alpha: 0.6)),
        ),
        child: TextField(
          controller: controller.searchController,
          onChanged: controller.onSearchChanged,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: _DC.onSurface,
          ),
          decoration: InputDecoration(
            hintText: 'Cari catatan...',
            hintStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: _DC.outline,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: _DC.outline,
              size: 20,
            ),
            suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                ? GestureDetector(
                    onTap: controller.clearSearch,
                    child: const Icon(
                      Icons.close,
                      color: _DC.outline,
                      size: 18,
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
    );
  }

  // ─── Filter Chips ─────────────────────────────────────────────────────────────
  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChip(
                  label: 'Semua',
                  isSelected: controller.selectedTipeFilter.value == null,
                  onTap: () => controller.setTipeFilter(null),
                ),
                const SizedBox(width: 10),
                _buildChip(
                  label: 'Pemasukan',
                  isSelected: controller.selectedTipeFilter.value ==
                      TipeCatatan.pemasukan,
                  onTap: () => controller.setTipeFilter(TipeCatatan.pemasukan),
                  activeColor: _DC.primary,
                ),
                const SizedBox(width: 10),
                _buildChip(
                  label: 'Pengeluaran',
                  isSelected: controller.selectedTipeFilter.value ==
                      TipeCatatan.pengeluaran,
                  onTap: () =>
                      controller.setTipeFilter(TipeCatatan.pengeluaran),
                  activeColor: _DC.error,
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? activeColor,
  }) {
    final chipColor = activeColor ?? _DC.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : _DC.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? chipColor : _DC.white5,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? (activeColor == _DC.error ? Colors.white : _DC.onPrimary)
                : _DC.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  // ─── Insight Image Banner ─────────────────────────────────────────────────────
  Widget _buildInsightBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/insight.png',
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  // ─── Date Header ─────────────────────────────────────────────────────────────
  Widget _buildDateHeader(
    BuildContext context,
    DateTime date,
    List<CatatanModel> items,
    NumberFormat currencyFormat,
  ) {
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
      padding: const EdgeInsets.only(top: 4, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _DC.onSurfaceVariant,
              letterSpacing: 0.2,
            ),
          ),
          GestureDetector(
            onTap: () => _showFullDayCatatanModal(
                context, date, items, currencyFormat),
            child: const Row(
              children: [
                Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _DC.primary,
                  ),
                ),
                SizedBox(width: 2),
                Icon(Icons.chevron_right, size: 16, color: _DC.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFullDayCatatanModal(
    BuildContext context,
    DateTime date,
    List<CatatanModel> items,
    NumberFormat currencyFormat,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: const BoxDecoration(
            color: _DC.surfaceContainer,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _DC.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildDateHeader(context, date, items, currencyFormat),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _DarkCatatanCard(
                      catatan: items[index],
                      currencyFormat: currencyFormat,
                      isLast: index == items.length - 1,
                      onTap: () => CatatanDetailModal.show(context, items[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Empty State ──────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    final isSearchActive =
        controller.searchQuery.value.isNotEmpty || controller.isFilterActive;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _DC.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSearchActive
                    ? Icons.search_off
                    : Icons.sticky_note_2_outlined,
                size: 48,
                color: _DC.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isSearchActive ? 'Catatan tidak ditemukan' : 'Belum ada catatan',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _DC.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearchActive
                  ? 'Coba ubah kata kunci atau filter yang digunakan.'
                  : 'Mulai catat keuanganmu sekarang!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: _DC.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            if (!isSearchActive) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Tambah Catatan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _DC.primary,
                  foregroundColor: _DC.onPrimary,
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
                    color: _DC.primary,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

// ─── Dark Mode Catatan Card ───────────────────────────────────────────────────
class _DarkCatatanCard extends StatefulWidget {
  final CatatanModel catatan;
  final NumberFormat currencyFormat;
  final bool isLast;
  final VoidCallback onTap;

  const _DarkCatatanCard({
    required this.catatan,
    required this.currencyFormat,
    required this.onTap,
    this.isLast = false,
  });

  @override
  State<_DarkCatatanCard> createState() => _DarkCatatanCardState();
}

class _DarkCatatanCardState extends State<_DarkCatatanCard> {
  bool _pressed = false;
  bool _hovered = false;

  void _onTapDown(TapDownDetails _) => setState(() => _pressed = true);
  void _onTapUp(TapUpDetails _) {
    setState(() => _pressed = false);
    widget.onTap();
  }
  void _onTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    final isActive = _pressed || _hovered;
    final timeFormat = DateFormat('HH:mm', 'id_ID');
    final isPemasukan = widget.catatan.tipe == TipeCatatan.pemasukan;
    final nominalColor = isPemasukan ? _DC.primary : _DC.error;
    final nominalPrefix = isPemasukan ? '+' : '-';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: EdgeInsets.only(bottom: widget.isLast ? 16 : 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isActive
                ? _DC.surfaceContainerHigh
                : _DC.surfaceContainerLow,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isActive
                  ? _DC.primary.withValues(alpha: 0.6)
                  : _DC.outlineVariant,
              width: isActive ? 1.5 : 1.0,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: _DC.primary.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // ── Category Icon ──
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isActive
                      ? _DC.primary.withValues(alpha: 0.15)
                      : _DC.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  widget.catatan.kategoriIcon,
                  color: isActive
                      ? _DC.primary
                      : _DC.secondary,
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
                      widget.catatan.nama,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _DC.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          widget.catatan.kategori,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _DC.onSurfaceVariant,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: _DC.outline.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          timeFormat.format(widget.catatan.tanggal),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: _DC.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Nominal ──
              Text(
                '$nominalPrefix ${widget.currencyFormat.format(widget.catatan.nominal)}',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: nominalColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
