import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/statistik_controller.dart';

class StatistikView extends GetView<StatistikController> {
  const StatistikView({super.key});

  static const List<Color> _chartColors = [
    Color(0xFFB4CCF0),
    Color(0xFFA8C8BD),
    Color(0xFFC8C8A8),
    Color(0xFFC8A8A8),
    Color(0xFF8C97BD),
  ];

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

  String _formatNumber(num number) {
    final cleanString = number.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < cleanString.length; i++) {
      if (i > 0 && (cleanString.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(cleanString[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161616),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Background blur effect on left top
              Positioned(
                left: -100,
                top: -50,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  _buildMainBalance(),
                  const SizedBox(height: 32),
                  _buildMonthSelector(),
                  const SizedBox(height: 24),
                  _buildSwipeableCards(context),
                  const SizedBox(height: 32),
                  _buildRecentTransactions(),
                  const SizedBox(height: 100), // extra bottom padding for floating navbar
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainBalance() {
    return Obx(() {
      return Column(
        children: [
          Text(
            _formatRupiah(controller.netBalance),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Main balance',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildMonthSelector() {
    final List<String> months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    final selectedMonth = 'Januari'.obs;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Obx(() {
        return Row(
          children: months.map((month) {
            final isSelected = selectedMonth.value == month;
            return GestureDetector(
              onTap: () => selectedMonth.value = month,
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF81C383) : const Color(0xFF1C1C1C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  month,
                  style: TextStyle(
                    color: isSelected ? Colors.black87 : Colors.white54,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }

  Widget _buildSwipeableCards(BuildContext context) {
    return SizedBox(
      height: 320,
      child: PageView(
        controller: PageController(viewportFraction: 0.9),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildCashflowLineChartCard(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildCategoryDonutChartCard(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCashflowLineChartCard() {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(32),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2C2C2C),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cashflow', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Text('Total Balance', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2C2C),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.swap_horiz, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text('Price', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Obx(() => Text(
              _formatRupiah(controller.netBalance),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            )),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.cashflowData.isEmpty) return const Center(child: CircularProgressIndicator());

              double maxVal = 0;
              for (var data in controller.cashflowData) {
                if (data.income > maxVal) maxVal = data.income;
                if (data.expense > maxVal) maxVal = data.expense;
              }
              maxVal = maxVal * 1.2;
              
              List<FlSpot> spots = [];
              for (int i = 0; i < controller.cashflowData.length; i++) {
                spots.add(FlSpot(i.toDouble(), controller.cashflowData[i].income));
              }

              return LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (controller.cashflowData.length - 1).toDouble(),
                  minY: 0,
                  maxY: maxVal,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: const Color(0xFF81C383),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                          radius: 5,
                          color: const Color(0xFF81C383),
                          strokeWidth: 3,
                          strokeColor: const Color(0xFF1F1F1F),
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF81C383).withOpacity(0.4),
                            const Color(0xFF81C383).withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDonutChartCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2C2C2C),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bar_chart, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pengeluaran', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text('Berdasarkan kategori', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFF2C2C2C),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.swap_horiz, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Total Pengeluaran', style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4),
          Obx(() => Text(
            _formatRupiah(controller.totalExpense.value),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          )),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.categoryExpenses.isEmpty) return const Center(child: CircularProgressIndicator());
              
              double maxVal = 0;
              for (var cat in controller.categoryExpenses) {
                if (cat.amount > maxVal) maxVal = cat.amount;
              }
              maxVal = maxVal * 1.2;
              
              final barGroups = controller.categoryExpenses.asMap().entries.map((entry) {
                int idx = entry.key;
                var cat = entry.value;
                return BarChartGroupData(
                  x: idx,
                  barRods: [
                    BarChartRodData(
                      toY: cat.amount,
                      color: _chartColors[idx % _chartColors.length],
                      width: 16,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }).toList();

              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxVal,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(show: false),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: barGroups,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _compactCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  Widget _buildRecentTransactions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Transaksi Terakhir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const Text('Lihat Semua >', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 20),
          _buildTransactionItem(
            icon: Icons.shopping_bag_outlined,
            title: 'ZARA',
            date: 'Kemarin',
            category: 'Gaya Hidup',
            amount: '-750.000',
            isExpense: true,
            iconColor: const Color(0xFF3A6043),
          ),
          const SizedBox(height: 8),
          _buildTransactionItem(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Gaji',
            date: '20 Okt',
            category: 'Pendapatan',
            amount: '+15.000.000',
            isExpense: false,
            iconColor: const Color(0xFF3ED598),
          ),
          const SizedBox(height: 8),
          _buildTransactionItem(
            icon: Icons.restaurant_outlined,
            title: 'Bakmi GM',
            date: '20 Okt',
            category: 'Makanan',
            amount: '-85.000',
            isExpense: true,
            iconColor: const Color(0xFFE5A8A8),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required String title,
    required String date,
    required String category,
    required String amount,
    required bool isExpense,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161616), // Match background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.0), // White stroke
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFD9D9D9), // Agak lebih abu-abu pastel
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                const SizedBox(height: 4),
                Text('$date • $category', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Rp',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
