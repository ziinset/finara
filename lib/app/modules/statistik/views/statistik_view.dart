import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/statistik_controller.dart';

class StatistikView extends GetView<StatistikController> {
  const StatistikView({super.key});

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
      backgroundColor: const Color(0xFFF6F8F9), // Light grayish background
      appBar: AppBar(
        title: const Text('Statistik', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF426C4C),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
              _buildCategoryDonutChart(),
              const SizedBox(height: 16),
              _buildCategoryTable(),
              const SizedBox(height: 32), // bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      color: const Color(0xFF426C4C),
      padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16, top: 8),
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: controller.periods.map((period) {
            final isSelected = controller.selectedPeriod.value == period;
            return GestureDetector(
              onTap: () => controller.changePeriod(period),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF426C4C) : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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
      final balanceColor = controller.netBalance >= 0 ? const Color(0xFF28C76F) : Colors.redAccent;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    title: 'Pemasukan',
                    amount: _formatRupiah(controller.totalIncome.value),
                    icon: Icons.arrow_downward,
                    color: const Color(0xFF28C76F),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    title: 'Pengeluaran',
                    amount: _formatRupiah(controller.totalExpense.value),
                    icon: Icons.arrow_upward,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Saldo Bersih', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                  Text(
                    _formatRupiah(controller.netBalance),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: balanceColor),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _buildSummaryCard({required String title, required String amount, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 12),
          Text(amount, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildCashflowChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Grafik Cashflow', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: Obx(() {
              if (controller.cashflowData.isEmpty) return const Center(child: CircularProgressIndicator());
              
              double maxVal = 0;
              for (var data in controller.cashflowData) {
                if (data.income > maxVal) maxVal = data.income;
                if (data.expense > maxVal) maxVal = data.expense;
              }
              maxVal = maxVal * 1.2; // Add some top padding

              List<FlSpot> incomeSpots = controller.cashflowData.map((e) => FlSpot(e.x.toDouble(), e.income)).toList();
              List<FlSpot> expenseSpots = controller.cashflowData.map((e) => FlSpot(e.x.toDouble(), e.expense)).toList();

              return LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              _compactCurrency(value),
                              style: const TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${value.toInt()}',
                              style: const TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (controller.cashflowData.length - 1).toDouble(),
                  minY: 0,
                  maxY: maxVal,
                  lineBarsData: [
                    LineChartBarData(
                      spots: incomeSpots,
                      isCurved: true,
                      color: const Color(0xFF28C76F),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF28C76F).withOpacity(0.1),
                      ),
                    ),
                    LineChartBarData(
                      spots: expenseSpots,
                      isCurved: true,
                      color: Colors.redAccent,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.redAccent.withOpacity(0.1),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => Colors.blueGrey.shade800,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final textStyle = TextStyle(
                            color: touchedSpot.bar.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          );
                          return LineTooltipItem(
                            _formatRupiah(touchedSpot.y),
                            textStyle,
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendIndicator(const Color(0xFF28C76F), 'Pemasukan'),
              const SizedBox(width: 16),
              _buildLegendIndicator(Colors.redAccent, 'Pengeluaran'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLegendIndicator(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
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

  Widget _buildCategoryDonutChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Komposisi Pengeluaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Obx(() {
              if (controller.categoryExpenses.isEmpty) return const Center(child: CircularProgressIndicator());
              
              final sections = controller.categoryExpenses.map((cat) {
                return PieChartSectionData(
                  color: cat.color,
                  value: cat.amount,
                  title: '',
                  radius: 40,
                );
              }).toList();

              return Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: sections,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.categoryExpenses.map((cat) {
                        double percentage = (cat.amount / controller.totalExpense.value) * 100;
                        if (percentage.isNaN) percentage = 0;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(color: cat.color, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${cat.name} (${percentage.toStringAsFixed(1)}%)',
                                  style: const TextStyle(fontSize: 11, color: Colors.black87),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTable() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rincian Kategori', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.categoryExpenses.isEmpty) return const SizedBox.shrink();
            
            return Column(
              children: controller.categoryExpenses.map((cat) {
                double percentage = (cat.amount / controller.totalExpense.value) * 100;
                if (percentage.isNaN) percentage = 0;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cat.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(cat.icon, color: cat.color, size: 24),
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
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
