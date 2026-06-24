import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeDashboardView extends GetView<HomeController> {
  const HomeDashboardView({super.key});

  // Helper to format currency to Indonesian Rupiah (Rp)
  String _formatRupiah(num number) {
    final cleanString = number.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < cleanString.length; i++) {
      if (i > 0 && (cleanString.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(cleanString[i]);
    }
    return 'Rp ${buffer.toString()}';
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Makan':
        return Icons.restaurant;
      case 'Transportasi':
        return Icons.directions_car_filled_outlined;
      case 'Belanja':
        return Icons.shopping_bag_outlined;
      case 'Pemasukan':
        return Icons.monetization_on_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Makan':
        return const Color(0xFFFF9F43);
      case 'Transportasi':
        return const Color(0xFF00CFE8);
      case 'Belanja':
        return const Color(0xFF7367F0);
      case 'Pemasukan':
        return const Color(0xFF28C76F);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => controller.refreshDashboard(),
        color: const Color(0xFF3A6043),
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildSkeletonLoader();
          }

          final data = controller.periodData[controller.selectedPeriod.value] ?? {};
          final num balance = data['balance'] ?? 0;
          final num income = data['income'] ?? 0;
          final num expense = data['expense'] ?? 0;
          final double bonusBalance = data['bonusBalance'] ?? 0.0;
          final List topCategories = data['topCategories'] ?? [];
          final List recentTransactions = data['recentTransactions'] ?? [];

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Header Profile Row ───
                _buildProfileHeader(context),
                const SizedBox(height: 20),

                // ─── Total Balance Card ───
                _buildBalanceCard(context, balance, income, expense, bonusBalance),
                const SizedBox(height: 20),

                // ─── Period Selector Chips ───
                _buildPeriodSelector(),
                const SizedBox(height: 24),

                // ─── Top 3 Spending Categories ───
                if (expense > 0) ...[
                  _buildTopSpendingCategories(topCategories),
                  const SizedBox(height: 24),
                ],

                // ─── Transaksi Terbaru ───
                _buildRecentTransactions(recentTransactions),
                const SizedBox(height: 24),

                // ─── Insight & Quote Card ───
                _buildInsightCard(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Profile image / Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
                gradient: const LinearGradient(
                  colors: [Color(0xFF86A38F), Color(0xFF3A6043)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.sports_soccer_outlined, // Soccer ball style matching image
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mr Henderson',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF40342B),
                  ),
                ),
                Text(
                  'Bet player2k',
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color(0xFF40342B).withOpacity(0.65),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Translucent Pill Capsule Actions
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF3A6043).withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF3A6043).withOpacity(0.12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => controller.toggleCardExpanded(),
                child: Icon(
                  controller.isCardExpanded.value
                      ? Icons.unfold_less
                      : Icons.unfold_more,
                  color: const Color(0xFF3A6043),
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 1,
                height: 14,
                color: const Color(0xFF3A6043).withOpacity(0.2),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Get.snackbar(
                    'Ubah Profil',
                    'Fitur edit profil akan segera hadir!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFF3A6043),
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                  );
                },
                child: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF3A6043),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(
    BuildContext context,
    num balance,
    num income,
    num expense,
    double bonusBalance,
  ) {
    final double cardRadius = 24.0;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardRadius),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3A6043), // Organic dark green
            Color(0xFF26442F), // Deep forest green
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3A6043).withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardRadius),
        child: Stack(
          children: [
            // ─── Watermark Trophy Overlay ───
            Positioned(
              right: -10,
              bottom: -15,
              child: Opacity(
                opacity: 0.08,
                child: const Icon(
                  Icons.emoji_events_outlined,
                  size: 170,
                  color: Colors.white,
                ),
              ),
            ),

            // Card Content Padding
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Card Header Row ───
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.wallet_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Main account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      // Dropdown Currency Indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.tealAccent.shade400,
                              child: const Text(
                                'R',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'IDR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ─── Main Balance Text ───
                  Text(
                    _formatRupiah(balance),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),

                  // Animated Expansion Block
                  AnimatedCrossFade(
                    firstChild: const SizedBox(height: 8),
                    secondChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 18),
                        // ─── Translucent Pemasukan & Pengeluaran Pill Bar ───
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(0.08)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_downward,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Pemasukan: ',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    _formatRupiah(income),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 1,
                                height: 16,
                                color: Colors.white.withOpacity(0.15),
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_upward,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Pengeluaran: ',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    _formatRupiah(expense),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ─── Bottom CTA Card Buttons ───
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Get.snackbar(
                                    'Pemasukan',
                                    'Fitur catat pemasukan akan segera dibuka!',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.white,
                                    colorText: Colors.black,
                                    margin: const EdgeInsets.all(16),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 13),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      )
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Catat Masuk',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Get.snackbar(
                                    'Pengeluaran',
                                    'Fitur catat pengeluaran akan segera dibuka!',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.black.withOpacity(0.4),
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(16),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 13),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '+ Catat Keluar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    crossFadeState: controller.isCardExpanded.value
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['Hari Ini', 'Minggu Ini', 'Bulan Ini'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: periods.map((period) {
        final isSelected = controller.selectedPeriod.value == period;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: GestureDetector(
            onTap: () => controller.changePeriod(period),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF3A6043)
                    : const Color(0xFF3A6043).withOpacity(0.06),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF3A6043)
                      : const Color(0xFF3A6043).withOpacity(0.12),
                ),
              ),
              child: Text(
                period,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF3A6043),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopSpendingCategories(List categories) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kategori Terbesar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF40342B),
            ),
          ),
          const SizedBox(height: 16),
          ...categories.map((cat) {
            final String name = cat['name'] ?? '';
            final double percentage = (cat['percentage'] as num?)?.toDouble() ?? 0.0;
            final num amount = cat['amount'] ?? 0;
            if (percentage == 0) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getCategoryIcon(name),
                            size: 18,
                            color: _getCategoryColor(name),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF40342B),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            _formatRupiah(amount),
                            style: TextStyle(
                              fontSize: 13,
                              color: const Color(0xFF40342B).withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${percentage.toInt()}%',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF40342B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey.withOpacity(0.12),
                      valueColor: AlwaysStoppedAnimation<Color>(_getCategoryColor(name)),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(List transactions) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transaksi Terbaru',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF40342B),
              ),
            ),
            TextButton(
              onPressed: () => controller.changePage(1),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF3A6043),
              ),
              child: const Row(
                children: [
                  Text(
                    'Lihat Semua',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 12),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (transactions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'Belum ada transaksi di periode ini',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final tx = transactions[index];
              final String title = tx['title'] ?? '';
              final String category = tx['category'] ?? '';
              final String time = tx['time'] ?? '';
              final num amount = tx['amount'] ?? 0;
              final isExpense = amount < 0;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.015),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    // Icon Category Circle
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: _getCategoryColor(category).withOpacity(0.12),
                      child: Icon(
                        _getCategoryIcon(category),
                        color: _getCategoryColor(category),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF40342B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 11,
                              color: const Color(0xFF40342B).withOpacity(0.45),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      isExpense
                          ? '- ${_formatRupiah(amount.abs())}'
                          : '+ ${_formatRupiah(amount)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isExpense ? Colors.red.shade600 : Colors.green.shade600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildInsightCard() {
    final quote = controller.quotes[controller.activeQuoteIndex.value];
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFEADD).withOpacity(0.85), // Warm sandy box
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFEADD)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background floating accents
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: Opacity(
              opacity: 0.15,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuB06ywqykBPkc_QN_Js5cbyH63wUjwtS-2rjHO_9tze63lEHlWHF4eENniX-QQpJnaoXMAmFm_ER4LTmS1WIcBwiriXvzb43mdqRb-1FWmVeC3N2EsZmO3GROEHx1Jq9mz_PGmXD2mDpv9UQbEr1lpZJpnr5bF7BUwhUTKEAzJ2oHRyiB_CZTrt6Ra1OoLb9UMBlwaRTOB64hzeo0kCG0YsjeMZad7_hIaynSt-CJGjQoBfXHvOuTe_FyVm6bloMOxsNuAG5JRtJ-bR',
                fit: BoxFit.cover,
                width: 140,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline_rounded,
                            color: Colors.amber.shade800,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Tips Keuangan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF40342B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '"$quote"',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                          color: Color(0xFF7A7067),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Small character image container
                Container(
                  width: 55,
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuB06ywqykBPkc_QN_Js5cbyH63wUjwtS-2rjHO_9tze63lEHlWHF4eENniX-QQpJnaoXMAmFm_ER4LTmS1WIcBwiriXvzb43mdqRb-1FWmVeC3N2EsZmO3GROEHx1Jq9mz_PGmXD2mDpv9UQbEr1lpZJpnr5bF7BUwhUTKEAzJ2oHRyiB_CZTrt6Ra1OoLb9UMBlwaRTOB64hzeo0kCG0YsjeMZad7_hIaynSt-CJGjQoBfXHvOuTe_FyVm6bloMOxsNuAG5JRtJ-bR',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.spa_outlined,
                      size: 40,
                      color: Color(0xFF3A6043),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Beautiful Skeleton Screen Shimmer Loader ───
  Widget _buildSkeletonLoader() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row Skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildSkeletonCircle(50),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSkeletonBar(width: 100, height: 16),
                      const SizedBox(height: 6),
                      _buildSkeletonBar(width: 60, height: 12),
                    ],
                  ),
                ],
              ),
              _buildSkeletonBar(width: 80, height: 32, borderRadius: 20),
            ],
          ),
          const SizedBox(height: 20),

          // Balance Card Skeleton
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black.withOpacity(0.03)),
            ),
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSkeletonBar(width: 120, height: 16),
                    _buildSkeletonBar(width: 60, height: 24, borderRadius: 12),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSkeletonBar(width: 200, height: 36),
                const Spacer(),
                Row(
                  children: [
                    Expanded(child: _buildSkeletonBar(height: 40, borderRadius: 20)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildSkeletonBar(height: 40, borderRadius: 20)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Period Chips Skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: _buildSkeletonBar(width: 80, height: 36, borderRadius: 20),
            )),
          ),
          const SizedBox(height: 30),

          // Categories Skeleton
          _buildSkeletonBar(width: 140, height: 20),
          const SizedBox(height: 16),
          ...List.generate(2, (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSkeletonBar(width: 100, height: 16),
                    _buildSkeletonBar(width: 40, height: 16),
                  ],
                ),
                const SizedBox(height: 8),
                _buildSkeletonBar(width: double.infinity, height: 8, borderRadius: 4),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSkeletonBar({
    required double height,
    double width = double.infinity,
    double borderRadius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  Widget _buildSkeletonCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFE2E2E2),
        shape: BoxShape.circle,
      ),
    );
  }
}
