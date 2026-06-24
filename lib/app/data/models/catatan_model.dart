import 'package:flutter/material.dart';

/// Tipe catatan keuangan
enum TipeCatatan { pemasukan, pengeluaran }

/// Opsi sorting catatan
enum SortType { terbaru, terlama, nominalTerbesar, nominalTerkecil }

/// Helper class untuk mapping kategori ke ikon dan warna
class KategoriItem {
  final String nama;
  final IconData icon;
  final Color color;

  const KategoriItem({
    required this.nama,
    required this.icon,
    required this.color,
  });
}

/// Daftar kategori pengeluaran sesuai PRD §5.3.1
const List<KategoriItem> kategoriPengeluaran = [
  KategoriItem(nama: 'Kuliner', icon: Icons.restaurant, color: Color(0xFFFF8A65)),
  KategoriItem(nama: 'Transportasi', icon: Icons.directions_car, color: Color(0xFF4FC3F7)),
  KategoriItem(nama: 'Belanja', icon: Icons.shopping_bag, color: Color(0xFFBA68C8)),
  KategoriItem(nama: 'Kesehatan', icon: Icons.medical_services, color: Color(0xFFEF5350)),
  KategoriItem(nama: 'Hiburan', icon: Icons.sports_esports, color: Color(0xFFFFD54F)),
  KategoriItem(nama: 'Pendidikan', icon: Icons.menu_book, color: Color(0xFF7986CB)),
  KategoriItem(nama: 'Tagihan', icon: Icons.lightbulb, color: Color(0xFFFFB74D)),
  KategoriItem(nama: 'Perawatan Diri', icon: Icons.spa, color: Color(0xFFF48FB1)),
  KategoriItem(nama: 'Olahraga', icon: Icons.fitness_center, color: Color(0xFF81C784)),
  KategoriItem(nama: 'Sosial', icon: Icons.people, color: Color(0xFF4DB6AC)),
  KategoriItem(nama: 'Rumah', icon: Icons.home, color: Color(0xFFA1887F)),
  KategoriItem(nama: 'Lainnya', icon: Icons.more_horiz, color: Color(0xFF90A4AE)),
];

/// Daftar kategori pemasukan sesuai PRD §5.3.2
const List<KategoriItem> kategoriPemasukan = [
  KategoriItem(nama: 'Gaji', icon: Icons.work, color: Color(0xFF66BB6A)),
  KategoriItem(nama: 'Bonus', icon: Icons.card_giftcard, color: Color(0xFFFFCA28)),
  KategoriItem(nama: 'Freelance', icon: Icons.laptop_mac, color: Color(0xFF42A5F5)),
  KategoriItem(nama: 'Bisnis', icon: Icons.store, color: Color(0xFFAB47BC)),
  KategoriItem(nama: 'Investasi', icon: Icons.trending_up, color: Color(0xFF26A69A)),
  KategoriItem(nama: 'Hadiah', icon: Icons.redeem, color: Color(0xFFEC407A)),
  KategoriItem(nama: 'Penjualan', icon: Icons.sell, color: Color(0xFFFFA726)),
  KategoriItem(nama: 'Lainnya', icon: Icons.more_horiz, color: Color(0xFF90A4AE)),
];

/// Semua kategori digabung
List<KategoriItem> get semuaKategori => [...kategoriPengeluaran, ...kategoriPemasukan];

/// Cari KategoriItem berdasarkan nama
KategoriItem? cariKategori(String nama, TipeCatatan tipe) {
  final list = tipe == TipeCatatan.pengeluaran ? kategoriPengeluaran : kategoriPemasukan;
  try {
    return list.firstWhere((k) => k.nama == nama);
  } catch (_) {
    return null;
  }
}

/// Model data catatan keuangan
class CatatanModel {
  final String id;
  final String nama;
  final TipeCatatan tipe;
  final String kategori;
  final double nominal;
  final DateTime tanggal;
  final String? catatan;

  const CatatanModel({
    required this.id,
    required this.nama,
    required this.tipe,
    required this.kategori,
    required this.nominal,
    required this.tanggal,
    this.catatan,
  });

  /// Icon & color dari kategori
  KategoriItem? get kategoriItem => cariKategori(kategori, tipe);
  IconData get kategoriIcon => kategoriItem?.icon ?? Icons.more_horiz;
  Color get kategoriColor => kategoriItem?.color ?? const Color(0xFF90A4AE);

  /// Warna tipe: hijau untuk pemasukan, merah untuk pengeluaran
  Color get tipeColor => tipe == TipeCatatan.pemasukan
      ? const Color(0xFF4CAF50)
      : const Color(0xFFE53935);

  /// Label tipe
  String get tipeLabel => tipe == TipeCatatan.pemasukan ? 'Pemasukan' : 'Pengeluaran';

  /// Prefix nominal (+/-)
  String get nominalPrefix => tipe == TipeCatatan.pemasukan ? '+' : '-';

  /// Copy with
  CatatanModel copyWith({
    String? id,
    String? nama,
    TipeCatatan? tipe,
    String? kategori,
    double? nominal,
    DateTime? tanggal,
    String? catatan,
  }) {
    return CatatanModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      tipe: tipe ?? this.tipe,
      kategori: kategori ?? this.kategori,
      nominal: nominal ?? this.nominal,
      tanggal: tanggal ?? this.tanggal,
      catatan: catatan ?? this.catatan,
    );
  }
}
