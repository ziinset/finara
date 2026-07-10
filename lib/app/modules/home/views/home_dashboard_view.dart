import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'notification_view.dart';
import '../../wallet/controllers/wallet_controller.dart';
import '../../wallet/views/create_wallet_view.dart';

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
        return const Color(0xFFFFB3A7); // pastel coral
      case 'Transportasi':
        return const Color(0xFFA7D8FF); // pastel sky blue
      case 'Belanja':
        return const Color(0xFFCDB4FF); // pastel lavender
      case 'Pemasukan':
        return const Color(0xFFA8E6CF); // pastel mint green
      default:
        return const Color(0xFFD1D1D1); // pastel grey
    }
  }

  String _getCategoryDescription(String category) {
    switch (category) {
      case 'Makan':
        return 'Jajan, restoran, dan kebutuhan makan';
      case 'Transportasi':
        return 'Bensin, tol, dan transportasi umum';
      case 'Belanja':
        return 'Belanja kebutuhan dan hiburan';
      case 'Pemasukan':
        return 'Gaji, bonus, dan pendapatan lain';
      default:
        return 'Pengeluaran lainnya';
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
            color: const Color(0xFF161616),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNewHeaderCard(context, balance, income, expense),
                  const SizedBox(height: 2),
                  _buildFinancialInsightBanner(),
                  const SizedBox(height: 28),

                // ─── Bottom Section with White Background ───
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF161616),
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
    return Stack(
      children: [
        // Background image positioned higher, covers down to the bottom of the header card padding
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 24,
          child: Opacity(
            opacity: 0.8,
            child: Image.asset(
              'assets/images/bg12.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),
          ),
        ),
        // Main content
        Container(
          width: double.infinity,
          color: Colors.transparent,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 24),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello, Sajibur', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Text('Selamat datang kembali', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const NotificationView()),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white.withOpacity(0.08),
                          child: const Icon(Icons.notifications_none, color: Colors.white, size: 25),
                        ),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF82C836),
                              shape: BoxShape.circle,
                            ),
                            child: const Text('2', style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Inner Dark Card with grey bg + image overlay
              Container(
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: const Color(0xFF232323),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.8),
                ),
                child: Stack(
                  children: [
                    // Subtle top inner glow
                    Positioned(
                      top: -30,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.topCenter,
                            radius: 1.2,
                            colors: [
                              Colors.white.withOpacity(0.07),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Right side image (1.png)
                    Positioned(
                      right: -10,
                      top: 10,
                      bottom: 10,
                      child: Opacity(
                        opacity: 0.15,
                        child: Image.asset(
                          'assets/images/1.png',
                          height: 140,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const SizedBox(),
                        ),
                      ),
                    ),
                    // Card content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => _showWalletSelector(context),
                                child: Row(
                                  children: [
                                    Obx(() => Text(
                                      controller.selectedWalletName.value,
                                      style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
                                    )),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 16),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Get.to(() => const CreateWalletView()),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    children: [
                                      Text('Add Wallet', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                      SizedBox(width: 4),
                                      Icon(Icons.add, color: Colors.white70, size: 14),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatRupiah(balance),
                            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '+22.7%', 
                            style: TextStyle(color: Color(0xFF82C836), fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          
                          // Income & Expense Bar
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                                          child: const Icon(Icons.arrow_downward, color: Colors.white, size: 12),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Pemasukan', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                              Text(_formatRupiah(income), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(width: 1, height: 30, color: Colors.white.withOpacity(0.3)),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(color: Color(0xFFE53935), shape: BoxShape.circle),
                                          child: const Icon(Icons.arrow_upward, color: Colors.white, size: 12),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Pengeluaran', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                              Text(_formatRupiah(expense), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showWalletSelector(BuildContext context) {
    final walletController = Get.find<WalletController>();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Wallet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: walletController.wallets.length + 1,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.white.withOpacity(0.1),
                      height: 1,
                      thickness: 1,
                    ),
                    itemBuilder: (context, index) {
                      if (index == walletController.wallets.length) {
                        // "Semua Wallet" option
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.account_balance, color: Colors.white70, size: 20),
                          ),
                          title: const Text('Semua Wallet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                          onTap: () {
                            Get.back();
                            // Implementation for all wallets
                            Get.snackbar('Fitur', 'Tampilan Semua Wallet akan datang', colorText: Colors.white);
                          },
                        );
                      }
                      
                      final wallet = walletController.wallets[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: wallet.color.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(wallet.icon, color: wallet.color, size: 20),
                        ),
                        title: Text(wallet.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                        subtitle: Text(
                          _formatRupiah(wallet.balance),
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
                        ),
                        trailing: wallet.isActive
                            ? const Icon(Icons.check_circle, color: Color(0xFF82C836), size: 24)
                            : null,
                        onTap: () {
                          walletController.selectWallet(wallet.id);
                          Get.back();
                        },
                      );
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFinancialInsightBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30, width: 0.8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                      fontSize: 13.5,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white54, width: 0.8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ayo mulai',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, color: Colors.white, size: 11),
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
                child: Opacity(
                  opacity: 0.9,
                  child: Image.asset(
                    'assets/images/koin2.png',
                    width: 60,
                    height: 60,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 50,
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

  Widget _buildTopSpendingCategories(List categories) {
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
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF232323),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ValueListenableBuilder<String>(
                  valueListenable: _selectedMonthNotifier,
                  builder: (context, selected, _) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selected,
                        isDense: true,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.white),
                        dropdownColor: const Color(0xFF232323),
                        style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
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
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildBentoTopCard(categories.isNotEmpty ? categories[0] : null),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBentoTopCard(categories.length > 1 ? categories[1] : null),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBentoBottomCard(categories.length > 2 ? categories[2] : null),
        ],
      ),
    );
  }

  Widget _buildBentoTopCard(dynamic cat) {
    if (cat == null) return const SizedBox();
    final String name = cat['name'] ?? '';
    final num amount = cat['amount'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF232323),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF2D2D2D),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getCategoryIcon(name), color: _getCategoryColor(name), size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(
                      _getCategoryDescription(name),
                      style: const TextStyle(color: Colors.white54, fontSize: 11, height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              _formatRupiah(amount),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoBottomCard(dynamic cat) {
    if (cat == null) return const SizedBox();
    final String name = cat['name'] ?? '';
    final num amount = cat['amount'] ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF232323),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFF2D2D2D),
              shape: BoxShape.circle,
            ),
            child: Icon(_getCategoryIcon(name), color: _getCategoryColor(name), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(_getCategoryDescription(name), style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Rp', style: TextStyle(color: Colors.white54, fontSize: 11)),
              const SizedBox(height: 2),
              Text(
                amount.toInt().toString().replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]}.',
                ),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
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
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 0),
              child: TextButton(
                onPressed: () => controller.changePage(1),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.only(right: 0, left: 8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lihat Semua',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (transactions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'Belum ada transaksi di periode ini',
                style: TextStyle(color: Colors.white54),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.white.withOpacity(0.2),
              height: 1,
              thickness: 0.6,
            ),
            itemBuilder: (context, index) {
              final tx = transactions[index];
              final String title = tx['title'] ?? '';
              final String category = tx['category'] ?? '';
              final String time = tx['time'] ?? '';
              final num amount = tx['amount'] ?? 0;
              final isExpense = amount < 0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    // Icon Category Circle with pastel bg
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2D2D2D),
                        shape: BoxShape.circle,
                      ),
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
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white54,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isExpense
                              ? '- ${_formatRupiah(amount.abs())}'
                              : '+ ${_formatRupiah(amount)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isExpense ? Colors.red.shade400 : Colors.green.shade400,
                          ),
                        ),
                      ],
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
