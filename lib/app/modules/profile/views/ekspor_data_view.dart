import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EksporDataView extends StatelessWidget {
  const EksporDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBE0),
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ekspor Data', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Color(0xFF4A3933), fontSize: 18)),
            SizedBox(width: 8),
            Icon(Icons.workspace_premium, color: Color(0xFFFFD700), size: 20),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF4A3933)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih rentang tanggal dan filter untuk mengekspor data catatan keuangan Anda.',
              style: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A3933)),
            ),
            const SizedBox(height: 24),
            
            _buildLabel('Rentang Tanggal'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildDropdown('Tgl Mulai', '01 Jun 2026')),
                const SizedBox(width: 16),
                Expanded(child: _buildDropdown('Tgl Akhir', '30 Jun 2026')),
              ],
            ),
            const SizedBox(height: 20),

            _buildLabel('Tipe Catatan'),
            const SizedBox(height: 8),
            _buildDropdown('Pilih Tipe', 'Semua Tipe (Pemasukan & Pengeluaran)'),
            const SizedBox(height: 20),

            _buildLabel('Kategori'),
            const SizedBox(height: 8),
            _buildDropdown('Pilih Kategori', 'Semua Kategori'),
            
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.snackbar('Berhasil', 'File Excel sedang diunduh', backgroundColor: Colors.white);
                },
                icon: const Icon(Icons.table_chart, color: Colors.white),
                label: const Text('Ekspor ke Excel (.xlsx)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3A6043), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.snackbar('Berhasil', 'File PDF sedang diunduh', backgroundColor: Colors.white);
                },
                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                label: const Text('Ekspor ke PDF (.pdf)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD32F2F), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Color(0xFF4A3933)));
  }

  Widget _buildDropdown(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(value, style: const TextStyle(fontFamily: 'Inter', color: Color(0xFF2D2D2D)), overflow: TextOverflow.ellipsis)),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }
}
