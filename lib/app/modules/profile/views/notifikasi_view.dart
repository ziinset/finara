import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifikasiView extends StatefulWidget {
  const NotifikasiView({super.key});

  @override
  State<NotifikasiView> createState() => _NotifikasiViewState();
}

class _NotifikasiViewState extends State<NotifikasiView> {
  bool pengingatHarian = true;
  bool ringkasanMingguan = true;
  bool ringkasanBulanan = true;
  bool pengeluaranBesar = false;
  bool tipsKeuangan = false;
  bool aktivitasAkun = true; // should be locked

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBE0),
      appBar: AppBar(
        title: const Text(
          'Notifikasi',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Color(0xFF4A3933), fontSize: 18),
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
            _buildSectionTitle('Sistem Bawaan'),
            const SizedBox(height: 12),
            _buildMenuCard([
              _buildToggleItem('Pengingat Harian', 'Ingatkan catat setiap hari', pengingatHarian, (v) => setState(() => pengingatHarian = v)),
              const Divider(height: 1),
              _buildToggleItem('Ringkasan Mingguan', 'Kirim ringkasan cashflow tiap akhir pekan', ringkasanMingguan, (v) => setState(() => ringkasanMingguan = v)),
              const Divider(height: 1),
              _buildToggleItem('Ringkasan Bulanan', 'Laporan bulanan setiap tanggal 1', ringkasanBulanan, (v) => setState(() => ringkasanBulanan = v)),
              const Divider(height: 1),
              _buildToggleItem('Pengeluaran Besar', 'Notif jika ada pengeluaran besar', pengeluaranBesar, (v) => setState(() => pengeluaranBesar = v)),
              const Divider(height: 1),
              _buildToggleItem('Tips Keuangan', 'Kirim tips/insight mingguan', tipsKeuangan, (v) => setState(() => tipsKeuangan = v)),
              const Divider(height: 1),
              _buildToggleItem('Aktivitas Akun', 'Info login & keamanan (Wajib)', aktivitasAkun, (v) {}, locked: true),
            ]),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle('Pengingat Kustom'),
                TextButton.icon(
                  onPressed: () {
                    // Logic tambah pengingat
                    Get.snackbar('Tambah', 'Fitur tambah pengingat kustom belum diaktifkan', backgroundColor: Colors.white);
                  },
                  icon: const Icon(Icons.add, color: Color(0xFF3A6043), size: 18),
                  label: const Text('Tambah', style: TextStyle(color: Color(0xFF3A6043), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Dummy Pengingat Kustom
            _buildCustomReminderItem(
              title: 'Pengingat Gajian',
              time: 'Tiap Tgl 1, 09:00',
              message: 'Hei, udah gajian nih! Waktunya ngisi Finara yuk 💰',
              isActive: true,
            ),
            const SizedBox(height: 12),
            _buildCustomReminderItem(
              title: 'Review Mingguan',
              time: 'Tiap Senin, 08:00',
              message: 'Awal minggu nih, jangan lupa catat pengeluaran!',
              isActive: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A3933)));
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Column(children: children));
  }

  Widget _buildToggleItem(String title, String subtitle, bool value, ValueChanged<bool> onChanged, {bool locked = false}) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, color: Color(0xFF4A3933))),
      subtitle: Text(subtitle, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey)),
      value: value,
      activeColor: const Color(0xFF3A6043),
      onChanged: locked ? null : onChanged,
    );
  }

  Widget _buildCustomReminderItem({required String title, required String time, required String message, required bool isActive}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Color(0xFF4A3933))),
              Switch(value: isActive, onChanged: (v) {}, activeColor: const Color(0xFF3A6043)),
            ],
          ),
          Text(time, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: Color(0xFF3A6043), fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('"$message"', style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }
}
