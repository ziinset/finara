import 'dart:math';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import 'package:finara/app/data/models/wallet_model.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  var isFabOpen = false.obs;

  // Mapping index ke route path
  static const List<String> tabRoutes = [
    Routes.HOME,
    Routes.CATATAN,
    Routes.STATISTIK,
    Routes.PROFILE,
  ];

  /// Sync currentIndex berdasarkan route yang sedang aktif
  void syncIndexFromRoute() {
    final route = Get.currentRoute;
    final index = tabRoutes.indexOf(route);
    if (index >= 0) {
      currentIndex.value = index;
    } else {
      currentIndex.value = 0;
    }
  }

  // Dashboard Reactive States
  var isLoading = false.obs;
  var selectedPeriod = 'Bulan Ini'.obs;
  
  // Wallet state
  var selectedWalletName = 'Main account'.obs;
  var activeWalletBalance = 114050000.0.obs;
  
  void updateActiveWallet(WalletModel wallet) {
    selectedWalletName.value = wallet.name;
    activeWalletBalance.value = wallet.balance;
    
    // In a real app, we would fetch transaction data for this specific wallet here.
    // For now, we update the balance in the mock data.
    if (periodData[selectedPeriod.value] != null) {
       periodData[selectedPeriod.value]!['balance'] = wallet.balance;
    }
  }

  var isCardExpanded = true.obs;
  var activeQuoteIndex = 0.obs;


  final List<String> quotes = [
    "Amankan masa depanmu! Setiap rupiah yang kamu sisihkan hari ini adalah batu bata untuk ketenangan hidupmu esok hari.",
    "Jangan menabung apa yang tersisa setelah dibelanjakan, tetapi belanjakanlah apa yang tersisa setelah ditabung.",
    "Aturlah uangmu, atau uangmu yang akan mengaturnya. Mulailah mengontrol finansialmu hari ini.",
    "Kekayaan sejati tidak diukur dari berapa banyak yang kamu hasilkan, melainkan dari berapa banyak yang bisa kamu kelola dan kembangkan.",
    "Disiplin finansial adalah jembatan antara tujuan finansial dan pencapaian finansial.",
  ];

  // Dynamic simulated data based on active period
  final Map<String, Map<String, dynamic>> periodData = {
    'Hari Ini': {
      'balance': 12450000,
      'income': 350000,
      'expense': 120000,
      'bonusBalance': 15.00,
      'topCategories': [
        {'name': 'Makan', 'percentage': 60.0, 'amount': 72000},
        {'name': 'Transportasi', 'percentage': 40.0, 'amount': 48000},
        {'name': 'Belanja', 'percentage': 0.0, 'amount': 0},
      ],
      'recentTransactions': [
        {
          'title': 'Makan Siang',
          'category': 'Makan',
          'time': '12:30 WIB',
          'amount': -72000,
        },
        {
          'title': 'Ojek Online',
          'category': 'Transportasi',
          'time': '08:15 WIB',
          'amount': -48000,
        },
        {
          'title': 'Transfer Masuk',
          'category': 'Pemasukan',
          'time': '07:00 WIB',
          'amount': 350000,
        },
      ],
    },
    'Minggu Ini': {
      'balance': 58900000,
      'income': 4500000,
      'expense': 1850000,
      'bonusBalance': 20.50,
      'topCategories': [
        {'name': 'Belanja', 'percentage': 40.0, 'amount': 740000},
        {'name': 'Makan', 'percentage': 35.0, 'amount': 647500},
        {'name': 'Transportasi', 'percentage': 25.0, 'amount': 462500},
      ],
      'recentTransactions': [
        {
          'title': 'Belanja Bulanan',
          'category': 'Belanja',
          'time': '22 Jun',
          'amount': -740000,
        },
        {
          'title': 'Makan Malam',
          'category': 'Makan',
          'time': '21 Jun',
          'amount': -310000,
        },
        {
          'title': 'Freelance Project',
          'category': 'Pemasukan',
          'time': '20 Jun',
          'amount': 2500000,
        },
        {
          'title': 'Transportasi Kantor',
          'category': 'Transportasi',
          'time': '19 Jun',
          'amount': -150000,
        },
        {
          'title': 'Kopi Santai',
          'category': 'Makan',
          'time': '18 Jun',
          'amount': -50000,
        },
      ],
    },
    'Bulan Ini': {
      'balance': 114050000,
      'income': 18200000,
      'expense': 9450000,
      'bonusBalance': 26.05,
      'topCategories': [
        {'name': 'Belanja', 'percentage': 45.0, 'amount': 4252500},
        {'name': 'Makan', 'percentage': 30.0, 'amount': 2835000},
        {'name': 'Transportasi', 'percentage': 25.0, 'amount': 2362500},
      ],
      'recentTransactions': [
        {
          'title': 'Sepatu Olahraga',
          'category': 'Belanja',
          'time': '24 Jun, 10:15',
          'amount': -1200000,
        },
        {
          'title': 'Gaji Utama',
          'category': 'Pemasukan',
          'time': '23 Jun, 09:00',
          'amount': 15000000,
        },
        {
          'title': 'Makan Bersama Keluarga',
          'category': 'Makan',
          'time': '22 Jun, 19:30',
          'amount': -850000,
        },
        {
          'title': 'Bensin & Tol',
          'category': 'Transportasi',
          'time': '21 Jun, 14:00',
          'amount': -400000,
        },
        {
          'title': 'Langganan Streaming',
          'category': 'Belanja',
          'time': '20 Jun, 08:00',
          'amount': -150000,
        },
      ],
    },
  };

  @override
  void onInit() {
    super.onInit();
    // Select a random quote on startup
    activeQuoteIndex.value = Random().nextInt(quotes.length);
  }

  void changePage(int index) {
    isFabOpen.value = false;
    if (currentIndex.value == index) return; // sudah di tab ini
    currentIndex.value = index;
    final targetRoute = tabRoutes[index];
    Get.offAllNamed(targetRoute);
  }

  void toggleFab() {
    isFabOpen.value = !isFabOpen.value;
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
  }

  void toggleCardExpanded() {
    isCardExpanded.value = !isCardExpanded.value;
  }

  Future<void> refreshDashboard() async {
    isLoading.value = true;
    // Simulate loading state for 1 second
    await Future.delayed(const Duration(milliseconds: 1000));
    // Pick a new random quote
    activeQuoteIndex.value = (activeQuoteIndex.value + 1) % quotes.length;
    isLoading.value = false;
  }
}
