import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryExpense {
  final String name;
  final IconData icon;
  final double amount;
  final Color color;

  CategoryExpense({
    required this.name,
    required this.icon,
    required this.amount,
    required this.color,
  });
}

class CashflowData {
  final int x;
  final double income;
  final double expense;

  CashflowData(this.x, this.income, this.expense);
}

class StatistikController extends GetxController {
  final periods = ['Hari', 'Minggu', 'Bulan', 'Tahun'];
  final selectedPeriod = 'Bulan'.obs;

  final totalIncome = 0.0.obs;
  final totalExpense = 0.0.obs;
  
  final cashflowData = <CashflowData>[].obs;
  final categoryExpenses = <CategoryExpense>[].obs;

  double get netBalance => totalIncome.value - totalExpense.value;

  @override
  void onInit() {
    super.onInit();
    _loadDataForPeriod(selectedPeriod.value);
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    _loadDataForPeriod(period);
  }

  void _loadDataForPeriod(String period) {
    // Generate dummy data based on the selected period
    final random = Random();
    List<CashflowData> newData = [];
    List<CategoryExpense> newCategories = [];
    double income = 0;
    double expense = 0;

    int dataPoints = 0;
    if (period == 'Hari') dataPoints = 4; // Every 6 hours
    else if (period == 'Minggu') dataPoints = 7; // Mon - Sun
    else if (period == 'Bulan') dataPoints = 4; // 4 Weeks or approx every 7 days
    else if (period == 'Tahun') dataPoints = 12; // Jan - Dec

    for (int i = 0; i < dataPoints; i++) {
      // Dummy multipliers depending on period
      double baseMultiplier = period == 'Tahun' ? 5000000 : (period == 'Bulan' ? 1000000 : (period == 'Minggu' ? 200000 : 50000));
      double inc = baseMultiplier + random.nextDouble() * baseMultiplier;
      double exp = (baseMultiplier * 0.5) + random.nextDouble() * (baseMultiplier * 0.8);
      newData.add(CashflowData(i, inc, exp));
      income += inc;
      expense += exp;
    }

    // Generate dummy category expenses
    final colors = [
      Colors.redAccent,
      Colors.orangeAccent,
      Colors.blueAccent,
      Colors.purpleAccent,
      Colors.cyanAccent,
    ];
    
    final names = ['Makanan', 'Transportasi', 'Tagihan', 'Hiburan', 'Belanja'];
    final icons = [
      Icons.fastfood,
      Icons.directions_car,
      Icons.receipt,
      Icons.movie,
      Icons.shopping_bag,
    ];

    double remainingExpense = expense;
    for (int i = 0; i < 5; i++) {
      double amount = i == 4 ? remainingExpense : remainingExpense * (random.nextDouble() * 0.4 + 0.1);
      if (amount < 0) amount = 0;
      remainingExpense -= amount;
      
      newCategories.add(CategoryExpense(
        name: names[i],
        icon: icons[i],
        amount: amount,
        color: colors[i],
      ));
    }
    
    // Sort categories by amount descending
    newCategories.sort((a, b) => b.amount.compareTo(a.amount));

    cashflowData.value = newData;
    categoryExpenses.value = newCategories;
    totalIncome.value = income;
    totalExpense.value = expense;
  }
}
