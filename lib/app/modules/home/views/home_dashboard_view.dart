import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'notification_view.dart';

class HomeDashboardView extends GetView<HomeController> {
  const HomeDashboardView({super.key});

  @override
  Widget build(BuildContext context) => const _HomeDashboardViewBody();
}

class _HomeDashboardViewBody extends StatefulWidget {
  const _HomeDashboardViewBody();

  @override
  State<_HomeDashboardViewBody> createState() => _HomeDashboardViewBodyState();
}

class _HomeDashboardViewBodyState extends State<_HomeDashboardViewBody> {
  HomeController get controller => Get.find<HomeController>();

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
        return Icons.restaurant_outlined;
      case 'Transportasi':
        return Icons.directions_car_outlined;
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

  final ValueNotifier<String> _selectedMonthNotifier = ValueNotifier<String>('Januari');
  final List<String> _months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];

  Widget _buildMonthSelector() {
    return ValueListenableBuilder<String>(
      valueListenable: _selectedMonthNotifier,
      builder: (context, selectedMonth, child) {
        return SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _months.length,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final month = _months[index];
              final isSelected = month == selectedMonth;
              return GestureDetector(
                onTap: () => _selectedMonthNotifier.value = month,
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF3A6043) : const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    month,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    );
  }

  @override
  void dispose() {
    _selectedMonthNotifier.dispose();
    super.dispose();
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

          return Container(
            color: Colors.white,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNewHeaderCard(context, balance, income, expense),
                  const SizedBox(height: 20),
                  _buildFinancialInsightBanner(),
                  const SizedBox(height: 24),

                // ─── Bottom Section with White Background ───
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.only(top: 0, bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── Top 3 Spending Categories ───
                      if (expense > 0) ...[
                        _buildTopSpendingCategories(topCategories),
                        const SizedBox(height: 24),
                      ],

                      // ─── Transaksi Terbaru ───
                      _buildRecentTransactions(recentTransactions),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNewHeaderCard(BuildContext context, num balance, num income, num expense) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.5,
          colors: [
            Color(0xFF7CAE8D), // Lighter top-left
            Color(0xFF3A6043), // Main green
            Color(0xFF2A4530), // Darker bottom-right
          ],
        ),
      ),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Profile, Greeting, Notification
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=150&auto=format&fit=crop'),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Haloo!!', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    Text('Kharisma Aretha', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Get.to(() => const NotificationView()),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: const Icon(Icons.notifications_none, color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Inner Transparent Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -10,
                  top: 20,
                  child: Image.asset(
                    'assets/images/uang.png',
                    width: 145,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main account row
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Obx(() => Text(controller.selectedWalletName.value, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.w600))),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatRupiah(balance),
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    
                    // Picture 2 Layout for Income & Expense
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                                  child: const Icon(Icons.arrow_downward, color: Colors.white, size: 12),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Pemasukan', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                    Text(_formatRupiah(income), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            )
                          ),
                          Container(width: 1, height: 24, color: Colors.white.withOpacity(0.3)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(color: Color(0xFFE53935), shape: BoxShape.circle),
                                  child: const Icon(Icons.arrow_upward, color: Colors.white, size: 12),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Pengeluaran', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                    Text(_formatRupiah(expense), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            )
                          ),
                        ],
                      ),
                    ),
                    // Buttons inside transparent card
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.toNamed('/wallet'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.swap_horiz, color: Color(0xFF3A6043), size: 16),
                                  SizedBox(width: 8),
                                  Text('Switch wallet', style: TextStyle(color: Color(0xFF3A6043), fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.toNamed('/wallet'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6B8C6C),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.account_balance_wallet, color: Colors.white, size: 16),
                                  SizedBox(width: 8),
                                  Text('Wallet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialInsightBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF5A8565), // Highlight
              Color(0xFF3A6043), // Base
              Color(0xFF26422D), // Shadow
            ],
            stops: [0.0, 0.4, 1.0],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Amankan Masa Depan,\nKelola Keuangan Lebih Terarah',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A6043),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ayo mulai',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, color: Colors.white, size: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Transform.scale(
                scale: 1.8,
                child: Image.asset(
                  'assets/images/koin.png',
                  width: 80,
                  height: 80,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.monetization_on,
                    color: Colors.amber,
                    size: 50,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSpendingCategories(List categories) {
    final greyColor = const Color(0xFFD5D5D5); // Slightly darker grey

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pengeluaran Terbesar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF40342B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                ),
                child: ValueListenableBuilder<String>(
                  valueListenable: _selectedMonthNotifier,
                  builder: (context, selected, _) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selected,
                        isDense: true,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                        style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.bold),
                        onChanged: (val) {
                          if (val != null) _selectedMonthNotifier.value = val;
                        },
                        items: _months.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...categories.map((cat) {
            final String name = cat['name'] ?? '';
            final double percentage = (cat['percentage'] as num?)?.toDouble() ?? 0.0;
            final num amount = cat['amount'] ?? 0;
            if (percentage == 0) return const SizedBox.shrink();

            // Description map per category
            final Map<String, String> categoryDesc = {
              'Belanja': 'Pengeluaran belanja bulan ini',
              'Makan': 'Pengeluaran makan & minuman',
              'Transportasi': 'Biaya transportasi & bensin',
            };
            final desc = categoryDesc[name] ?? 'Kategori pengeluaran';
            final lighterGrey = const Color(0xFFE8E8E8);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: lighterGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top white section
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: lighterGrey, width: 2),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE5F8ED),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getCategoryIcon(name),
                            color: const Color(0xFF2DC872),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Left: Title + desc
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                desc,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Right: Percentage + progress bar
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${percentage.toInt()}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 60,
                              child: LinearProgressIndicator(
                                value: percentage / 100,
                                backgroundColor: Colors.grey.shade200,
                                color: const Color(0xFF3A6043),
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Bottom grey section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      '- ${_formatRupiah(amount)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(List transactions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
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
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    // Icon Category Circle with Progress
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: isExpense ? 1.0 : 0.35,
                            backgroundColor: Colors.grey.shade100,
                            color: isExpense ? Colors.red.shade400 : Colors.green.shade400,
                            strokeWidth: 3,
                          ),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: Icon(
                              _getCategoryIcon(category),
                              color: _getCategoryColor(category),
                              size: 18,
                            ),
                          ),
                        ],
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
      ),
    );
  }

  Widget _buildInsightCard() {
    final quote = controller.quotes[controller.activeQuoteIndex.value];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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
