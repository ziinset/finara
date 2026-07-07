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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Statistik', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        titleSpacing: 32,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPeriodSelector(),
              const SizedBox(height: 16),
              _buildNumericSummary(),
              const SizedBox(height: 16),
              _buildCashflowChart(),
              const SizedBox(height: 16),
              _buildCategoryDonutChart(context),
              const SizedBox(height: 24),
              _buildRecentTransactions(),
              const SizedBox(height: 32), // bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: controller.periods.map((period) {
            final isSelected = controller.selectedPeriod.value == period;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.changePeriod(period),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF86A789) : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      period,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }

  Widget _buildNumericSummary() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(left: 32, right: 24),
        child: Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Pemasukan',
                amount: _formatRupiah(controller.totalIncome.value),
                icon: Icons.arrow_upward_rounded,
                color: const Color(0xFF3ED598),
                progress: 0.7,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: 'Pengeluaran',
                amount: _formatRupiah(controller.totalExpense.value),
                icon: Icons.arrow_downward_rounded,
                color: const Color(0xFFFF5C5C),
                progress: 0.4,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryCard({required String title, required String amount, required IconData icon, required Color color, required double progress}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.0),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  backgroundColor: color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Icon(icon, color: color, size: 24),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashflowChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cashflow', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Obx(() => Text(
            _formatRupiah(controller.netBalance),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: -0.5),
          )),
          const SizedBox(height: 24),
          SizedBox(
            height: 240,
            child: Obx(() {
              if (controller.cashflowData.isEmpty) return const Center(child: CircularProgressIndicator());

              double maxVal = 0;
              for (var data in controller.cashflowData) {
                if (data.income > maxVal) maxVal = data.income;
                if (data.expense > maxVal) maxVal = data.expense;
              }
              maxVal = maxVal * 1.3;

              List<BarChartGroupData> barGroups = [];
              for (int i = 0; i < controller.cashflowData.length; i++) {
                final data = controller.cashflowData[i];
                barGroups.add(
                  BarChartGroupData(
                    x: i,
                    barsSpace: 6,
                    barRods: [
                      BarChartRodData(
                        toY: data.income,
                        color: Colors.grey.shade800,
                        width: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      BarChartRodData(
                        toY: data.expense,
                        color: const Color(0xFF3A6043),
                        width: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  )
                );
              }

              return BarChart(
                BarChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxVal > 0 ? maxVal / 4 : 1,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1, dashArray: [5, 5]),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          if (value == 0 || value == maxVal) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              _compactCurrency(value),
                              style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                              textAlign: TextAlign.right,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${value.toInt()}',
                              style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  maxY: maxVal,
                  barGroups: barGroups,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => Colors.black87,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          _compactCurrency(rod.toY),
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                        );
                      }
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey.shade800, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text('Pemasukan', style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
              const SizedBox(width: 16),
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF3A6043), shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text('Pengeluaran', style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLegendGrid() {
    return Obx(() {
      if (controller.categoryExpenses.isEmpty) return const SizedBox.shrink();
      
      List<Widget> legendItems = [];
      for (int i = 0; i < controller.categoryExpenses.length; i++) {
        final cat = controller.categoryExpenses[i];
        final color = _chartColors[i % _chartColors.length];
        legendItems.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(cat.name, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
            ],
          )
        );
      }

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (legendItems.isNotEmpty) legendItems[0],
              if (legendItems.length > 1) const SizedBox(width: 20),
              if (legendItems.length > 1) legendItems[1],
              if (legendItems.length > 2) const SizedBox(width: 20),
              if (legendItems.length > 2) legendItems[2],
            ],
          ),
          if (legendItems.length > 3) const SizedBox(height: 12),
          if (legendItems.length > 3)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                legendItems[3],
                if (legendItems.length > 4) const SizedBox(width: 20),
                if (legendItems.length > 4) legendItems[4],
              ],
            ),
        ],
      );
    });
  }

  String _compactCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  Widget _buildCategoryDonutChart(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Komposisi Pengeluaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 32),
          SizedBox(
            height: 250,
            child: Obx(() {
              if (controller.categoryExpenses.isEmpty) return const Center(child: CircularProgressIndicator());
              
              final sections = controller.categoryExpenses.asMap().entries.map((entry) {
                int idx = entry.key;
                var cat = entry.value;
                double percentage = (cat.amount / controller.totalExpense.value) * 100;
                if (percentage.isNaN) percentage = 0;

                return PieChartSectionData(
                  color: _chartColors[idx % _chartColors.length],
                  value: cat.amount,
                  title: '',
                  radius: 50,
                  badgeWidget: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 6, height: 6, decoration: BoxDecoration(color: _chartColors[idx % _chartColors.length], shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Text('${percentage.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  badgePositionPercentageOffset: 1.2,
                );
              }).toList();

              return Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(enabled: true),
                      sectionsSpace: 4,
                      centerSpaceRadius: 60,
                      sections: sections,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Total Pengeluaran', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(
                        _compactCurrency(controller.totalExpense.value),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 32),
          Center(
            child: InkWell(
              onTap: () {
                _showTransactionPopup(context);
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300, width: 1.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('View all transactions', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          _buildLegendGrid(),
        ],
      ),
    );
  }

  void _showTransactionPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 16),
                const Text('All Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(() {
                    if (controller.categoryExpenses.isEmpty) {
                      return const Center(child: Text('Belum ada transaksi pengeluaran.'));
                    }
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.categoryExpenses.length,
                      itemBuilder: (context, index) {
                        final cat = controller.categoryExpenses[index];
                        double percentage = (cat.amount / controller.totalExpense.value) * 100;
                        if (percentage.isNaN) percentage = 0;
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _chartColors[index % _chartColors.length].withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(cat.icon, color: _chartColors[index % _chartColors.length], size: 24),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(cat.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                    const SizedBox(height: 4),
                                    Text('${percentage.toStringAsFixed(1)}% dari total', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Text(
                                _formatRupiah(cat.amount),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRecentTransactions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Transaksi Terakhir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              Text('Lihat Semua >', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF3A6043))),
            ],
          ),
          const SizedBox(height: 16),
          _buildTransactionItem(
            icon: Icons.shopping_bag_outlined,
            title: 'ZARA Fashion Indonesia',
            date: 'Kemarin • 14:20',
            category: 'Gaya Hidup',
            amount: '-Rp 750.000',
            isExpense: true,
          ),
          const SizedBox(height: 12),
          _buildTransactionItem(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Gaji Bulanan PT Maju Jaya',
            date: '20 Okt 2023 • 09:00',
            category: 'Pendapatan',
            amount: '+Rp 15.000.000',
            isExpense: false,
          ),
          const SizedBox(height: 12),
          _buildTransactionItem(
            icon: Icons.restaurant_outlined,
            title: 'Bakmi GM Thamrin',
            date: '20 Okt 2023 • 12:45',
            category: 'Makanan',
            amount: '-Rp 85.000',
            isExpense: true,
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
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.0),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isExpense ? const Color(0xFF3A6043).withOpacity(0.1) : const Color(0xFF3ED598).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isExpense ? const Color(0xFF3A6043) : const Color(0xFF3ED598), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(date, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isExpense ? const Color(0xFFB3261E) : const Color(0xFF3ED598),
                ),
              ),
              const SizedBox(height: 4),
              Text(category, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
