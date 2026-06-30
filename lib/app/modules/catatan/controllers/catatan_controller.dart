import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/catatan_model.dart';

class CatatanController extends GetxController {
  // ─── Master Data ───
  final allCatatan = <CatatanModel>[].obs;

  // ─── Filtered / Display Data ───
  final filteredCatatan = <CatatanModel>[].obs;

  // ─── Search ───
  final searchQuery = ''.obs;
  final searchController = TextEditingController();

  // ─── Filters ───
  final selectedTipeFilter = Rxn<TipeCatatan>(); // null = Semua
  final selectedKategoriFilter = <String>{}.obs;
  final dateRangeStart = Rxn<DateTime>();
  final dateRangeEnd = Rxn<DateTime>();
  final nominalMin = Rxn<double>();
  final nominalMax = Rxn<double>();

  // ─── Sort ───
  final selectedSortType = SortType.terbaru.obs;

  // ─── Computed ───
  bool get isFilterActive =>
      selectedTipeFilter.value != null ||
      selectedKategoriFilter.isNotEmpty ||
      dateRangeStart.value != null ||
      dateRangeEnd.value != null ||
      nominalMin.value != null ||
      nominalMax.value != null ||
      selectedSortType.value != SortType.terbaru;

  /// Catatan grouped by date for display
  Map<DateTime, List<CatatanModel>> get groupedCatatan {
    final map = <DateTime, List<CatatanModel>>{};
    for (final c in filteredCatatan) {
      final dateKey = DateTime(c.tanggal.year, c.tanggal.month, c.tanggal.day);
      map.putIfAbsent(dateKey, () => []).add(c);
    }
    return map;
  }

  /// Sorted date keys
  List<DateTime> get sortedDateKeys {
    final keys = groupedCatatan.keys.toList();
    if (selectedSortType.value == SortType.terlama) {
      keys.sort((a, b) => a.compareTo(b));
    } else {
      keys.sort((a, b) => b.compareTo(a));
    }
    return keys;
  }

  /// Total pemasukan dari filtered
  double get totalPemasukan => filteredCatatan
      .where((c) => c.tipe == TipeCatatan.pemasukan)
      .fold(0.0, (sum, c) => sum + c.nominal);

  /// Total pengeluaran dari filtered
  double get totalPengeluaran => filteredCatatan
      .where((c) => c.tipe == TipeCatatan.pengeluaran)
      .fold(0.0, (sum, c) => sum + c.nominal);

  @override
  void onInit() {
    super.onInit();
    _populateDummyData();
    _applyFiltersAndSort();

    // Auto-react to changes
    ever(searchQuery, (_) => _applyFiltersAndSort());
    ever(selectedTipeFilter, (_) => _applyFiltersAndSort());
    ever(selectedKategoriFilter, (_) => _applyFiltersAndSort());
    ever(dateRangeStart, (_) => _applyFiltersAndSort());
    ever(dateRangeEnd, (_) => _applyFiltersAndSort());
    ever(nominalMin, (_) => _applyFiltersAndSort());
    ever(nominalMax, (_) => _applyFiltersAndSort());
    ever(selectedSortType, (_) => _applyFiltersAndSort());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ─── Public Methods ───

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  void setTipeFilter(TipeCatatan? tipe) {
    selectedTipeFilter.value = tipe;
  }

  void toggleKategoriFilter(String kategori) {
    if (selectedKategoriFilter.contains(kategori)) {
      selectedKategoriFilter.remove(kategori);
    } else {
      selectedKategoriFilter.add(kategori);
    }
  }

  void setDateRange(DateTime? start, DateTime? end) {
    dateRangeStart.value = start;
    dateRangeEnd.value = end;
  }

  void setNominalRange(double? min, double? max) {
    nominalMin.value = min;
    nominalMax.value = max;
  }

  void setSortType(SortType type) {
    selectedSortType.value = type;
  }

  void resetAllFilters() {
    selectedTipeFilter.value = null;
    selectedKategoriFilter.clear();
    dateRangeStart.value = null;
    dateRangeEnd.value = null;
    nominalMin.value = null;
    nominalMax.value = null;
    selectedSortType.value = SortType.terbaru;
  }

  void deleteCatatan(String id) {
    allCatatan.removeWhere((c) => c.id == id);
    _applyFiltersAndSort();
    Get.back(); // close modal
    Get.snackbar(
      'Berhasil',
      'Catatan berhasil dihapus',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF3A6043),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  void updateCatatan(CatatanModel updated) {
    final index = allCatatan.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      allCatatan[index] = updated;
      _applyFiltersAndSort();
      Get.snackbar(
        'Berhasil',
        'Catatan berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF3A6043),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    }
  }

  // ─── Private Methods ───

  void _applyFiltersAndSort() {
    var result = List<CatatanModel>.from(allCatatan);

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      result = result.where((c) {
        return c.nama.toLowerCase().contains(q) ||
            c.kategori.toLowerCase().contains(q) ||
            c.nominal.toString().contains(q);
      }).toList();
    }

    // Tipe filter
    if (selectedTipeFilter.value != null) {
      result = result.where((c) => c.tipe == selectedTipeFilter.value).toList();
    }

    // Kategori filter
    if (selectedKategoriFilter.isNotEmpty) {
      result = result.where((c) => selectedKategoriFilter.contains(c.kategori)).toList();
    }

    // Date range filter
    if (dateRangeStart.value != null) {
      result = result.where((c) {
        final day = DateTime(c.tanggal.year, c.tanggal.month, c.tanggal.day);
        final start = DateTime(dateRangeStart.value!.year, dateRangeStart.value!.month, dateRangeStart.value!.day);
        return !day.isBefore(start);
      }).toList();
    }
    if (dateRangeEnd.value != null) {
      result = result.where((c) {
        final day = DateTime(c.tanggal.year, c.tanggal.month, c.tanggal.day);
        final end = DateTime(dateRangeEnd.value!.year, dateRangeEnd.value!.month, dateRangeEnd.value!.day);
        return !day.isAfter(end);
      }).toList();
    }

    // Nominal range filter
    if (nominalMin.value != null) {
      result = result.where((c) => c.nominal >= nominalMin.value!).toList();
    }
    if (nominalMax.value != null) {
      result = result.where((c) => c.nominal <= nominalMax.value!).toList();
    }

    // Sort
    switch (selectedSortType.value) {
      case SortType.terbaru:
        result.sort((a, b) => b.tanggal.compareTo(a.tanggal));
        break;
      case SortType.terlama:
        result.sort((a, b) => a.tanggal.compareTo(b.tanggal));
        break;
      case SortType.nominalTerbesar:
        result.sort((a, b) => b.nominal.compareTo(a.nominal));
        break;
      case SortType.nominalTerkecil:
        result.sort((a, b) => a.nominal.compareTo(b.nominal));
        break;
    }

    filteredCatatan.value = result;
  }

  void _populateDummyData() {
    final now = DateTime.now();

    allCatatan.value = [
      // ── Hari ini ──
      CatatanModel(
        id: '1',
        nama: 'Makan Siang Warteg',
        tipe: TipeCatatan.pengeluaran,
        kategori: 'Kuliner',
        nominal: 25000,
        tanggal: DateTime(now.year, now.month, now.day, 12, 30),
        catatan: 'Makan di warteg dekat kantor, nasi + ayam + sayur',
      ),
      CatatanModel(
        id: '2',
        nama: 'Grab ke Kantor',
        tipe: TipeCatatan.pengeluaran,
        kategori: 'Transportasi',
        nominal: 35000,
        tanggal: DateTime(now.year, now.month, now.day, 7, 45),
        catatan: 'Hujan pagi, terpaksa naik Grab',
      ),
      CatatanModel(
        id: '3',
        nama: 'Transfer dari Client',
        tipe: TipeCatatan.pemasukan,
        kategori: 'Freelance',
        nominal: 2500000,
        tanggal: DateTime(now.year, now.month, now.day, 10, 15),
        catatan: 'Pembayaran project desain logo',
      ),
      CatatanModel(
        id: '3_1',
        nama: 'Beli Kopi Sore',
        tipe: TipeCatatan.pengeluaran,
        kategori: 'Kuliner',
        nominal: 25000,
        tanggal: DateTime(now.year, now.month, now.day, 15, 30),
        catatan: 'Kopi susu gula aren',
      ),
      CatatanModel(
        id: '3_2',
        nama: 'Bayar Parkir',
        tipe: TipeCatatan.pengeluaran,
        kategori: 'Transportasi',
        nominal: 5000,
        tanggal: DateTime(now.year, now.month, now.day, 16, 00),
      ),

      // ── Kemarin ──
      CatatanModel(
        id: '4',
        nama: 'Belanja Bulanan',
        tipe: TipeCatatan.pengeluaran,
        kategori: 'Belanja',
        nominal: 450000,
        tanggal: DateTime(now.year, now.month, now.day - 1, 16, 0),
        catatan: 'Belanja di Alfamart, sabun, shampoo, snack, dll',
      ),
      CatatanModel(
        id: '5',
        nama: 'Kopi Starbucks',
        tipe: TipeCatatan.pengeluaran,
        kategori: 'Kuliner',
        nominal: 65000,
        tanggal: DateTime(now.year, now.month, now.day - 1, 14, 30),
      ),
      CatatanModel(
        id: '6',
        nama: 'Bayar Listrik',
        tipe: TipeCatatan.pengeluaran,
        kategori: 'Tagihan',
        nominal: 285000,
        tanggal: DateTime(now.year, now.month, now.day - 1, 9, 0),
        catatan: 'Tagihan listrik bulan Juni',
      ),

      // ── 2 hari lalu ──
      CatatanModel(
        id: '7',
        nama: 'Gaji Bulanan',
        tipe: TipeCatatan.pemasukan,
        kategori: 'Gaji',
        nominal: 8500000,
        tanggal: DateTime(now.year, now.month, now.day - 2, 8, 0),
        catatan: 'Gaji bulan Juni 2026, alhamdulillah!',
      ),
      CatatanModel(
        id: '8',
        nama: 'Gym Membership',
        tipe: TipeCatatan.pengeluaran,
        kategori: 'Olahraga',
        nominal: 350000,
        tanggal: DateTime(now.year, now.month, now.day - 2, 17, 30),
        catatan: 'Perpanjang member Gold Gym 1 bulan',
      ),

      // ── 3 hari lalu ──
      CatatanModel(
        id: '9',
        nama: 'Nonton Bioskop',
        tipe: TipeCatatan.pengeluaran,
        kategori: 'Hiburan',
        nominal: 100000,
        tanggal: DateTime(now.year, now.month, now.day - 3, 19, 0),
        catatan: 'Nonton film baru bareng teman',
      ),
      CatatanModel(
        id: '10',
        nama: 'Jual Barang Bekas',
        tipe: TipeCatatan.pemasukan,
        kategori: 'Penjualan',
        nominal: 150000,
        tanggal: DateTime(now.year, now.month, now.day - 3, 11, 0),
        catatan: 'Jual keyboard lama di marketplace',
      ),
      CatatanModel(
        id: '11',
        nama: 'Bayar Internet',
        tipe: TipeCatatan.pengeluaran,
        kategori: 'Tagihan',
        nominal: 399000,
        tanggal: DateTime(now.year, now.month, now.day - 3, 10, 0),
        catatan: 'IndiHome 100 Mbps',
      ),

      // ── 5 hari lalu ──
      CatatanModel(
        id: '12',
        nama: 'Beli Buku Programming',
        tipe: TipeCatatan.pengeluaran,
        kategori: 'Pendidikan',
        nominal: 189000,
        tanggal: DateTime(now.year, now.month, now.day - 5, 13, 0),
        catatan: 'Buku Flutter & Dart untuk pemula',
      ),
      CatatanModel(
        id: '13',
        nama: 'Hadiah Ulang Tahun Teman',
        tipe: TipeCatatan.pengeluaran,
        kategori: 'Sosial',
        nominal: 200000,
        tanggal: DateTime(now.year, now.month, now.day - 5, 15, 30),
      ),
      CatatanModel(
        id: '14',
        nama: 'Bonus Proyek',
        tipe: TipeCatatan.pemasukan,
        kategori: 'Bonus',
        nominal: 1000000,
        tanggal: DateTime(now.year, now.month, now.day - 5, 9, 0),
        catatan: 'Bonus dari bos karena deadline tercapai 🎉',
      ),

      // ── 7 hari lalu ──
      CatatanModel(
        id: '15',
        nama: 'Facial Treatment',
        tipe: TipeCatatan.pengeluaran,
        kategori: 'Perawatan Diri',
        nominal: 250000,
        tanggal: DateTime(now.year, now.month, now.day - 7, 11, 0),
        catatan: 'Perawatan wajah di klinik',
      ),
      CatatanModel(
        id: '16',
        nama: 'Servis AC',
        tipe: TipeCatatan.pengeluaran,
        kategori: 'Rumah',
        nominal: 175000,
        tanggal: DateTime(now.year, now.month, now.day - 7, 14, 0),
        catatan: 'Servis rutin AC kamar tidur',
      ),
      CatatanModel(
        id: '17',
        nama: 'Dividen Saham',
        tipe: TipeCatatan.pemasukan,
        kategori: 'Investasi',
        nominal: 425000,
        tanggal: DateTime(now.year, now.month, now.day - 7, 8, 0),
        catatan: 'Dividen BBCA Q2 2026',
      ),

      // ── 10 hari lalu ──
      CatatanModel(
        id: '18',
        nama: 'Bensin Motor',
        tipe: TipeCatatan.pengeluaran,
        kategori: 'Transportasi',
        nominal: 50000,
        tanggal: DateTime(now.year, now.month, now.day - 10, 7, 0),
      ),
      CatatanModel(
        id: '19',
        nama: 'THR dari Orang Tua',
        tipe: TipeCatatan.pemasukan,
        kategori: 'Hadiah',
        nominal: 500000,
        tanggal: DateTime(now.year, now.month, now.day - 10, 12, 0),
        catatan: 'THR dari mama 💚',
      ),
      CatatanModel(
        id: '20',
        nama: 'Obat Flu',
        tipe: TipeCatatan.pengeluaran,
        kategori: 'Kesehatan',
        nominal: 45000,
        tanggal: DateTime(now.year, now.month, now.day - 10, 20, 0),
        catatan: 'Paracetamol + vitamin C',
      ),
    ];
  }
}
