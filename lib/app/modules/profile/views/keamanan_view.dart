import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_password_view.dart';

class KeamananView extends StatefulWidget {
  const KeamananView({super.key});

  @override
  State<KeamananView> createState() => _KeamananViewState();
}

class _KeamananViewState extends State<KeamananView> {
  bool is2faEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Keamanan',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A3933),
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF4A3933)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Kata Sandi'),
              const SizedBox(height: 12),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.lock_reset,
                  title: 'Set / Ubah Password',
                  onTap: () => Get.to(() => const EditPasswordView()),
                ),
              ]),
              const SizedBox(height: 24),

              _buildSectionTitle('Autentikasi'),
              const SizedBox(height: 12),
              _buildMenuCard([
                _buildToggleItem(
                  icon: Icons.security,
                  title: 'Two-Factor Authentication (2FA)',
                  subtitle: is2faEnabled ? 'Aktif (OTP via Email)' : 'Nonaktif',
                  value: is2faEnabled,
                  onChanged: (val) {
                    setState(() {
                      is2faEnabled = val;
                    });
                    Get.snackbar(
                      'Status 2FA', 
                      val ? '2FA berhasil diaktifkan' : '2FA dinonaktifkan',
                      backgroundColor: Colors.white,
                    );
                  },
                ),
              ]),
              const SizedBox(height: 24),

              _buildSectionTitle('Sesi Aktif'),
              const SizedBox(height: 12),
              _buildMenuCard([
                _buildSessionItem(
                  device: 'iPhone 15 Pro',
                  location: 'Jakarta, Indonesia',
                  time: 'Aktif sekarang',
                  isCurrentDevice: true,
                ),
                const Divider(height: 1),
                _buildSessionItem(
                  device: 'MacBook Air M2',
                  location: 'Bandung, Indonesia',
                  time: 'Terakhir aktif: 2 jam lalu',
                  isCurrentDevice: false,
                  onLogout: () {
                    Get.snackbar('Sesi Ditutup', 'Berhasil keluar dari MacBook Air M2');
                  }
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4A3933),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4A3933)),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          color: Color(0xFF4A3933),
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: const Color(0xFF4A3933)),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          color: Color(0xFF4A3933),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: value ? const Color(0xFF3A6043) : Colors.grey,
        ),
      ),
      value: value,
      activeColor: const Color(0xFF3A6043),
      onChanged: onChanged,
    );
  }

  Widget _buildSessionItem({
    required String device,
    required String location,
    required String time,
    required bool isCurrentDevice,
    VoidCallback? onLogout,
  }) {
    return ListTile(
      leading: Icon(
        isCurrentDevice ? Icons.phone_iphone : Icons.laptop_mac,
        color: const Color(0xFF4A3933),
      ),
      title: Text(
        device,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D2D2D),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(location, style: const TextStyle(fontSize: 12)),
          Text(
            time, 
            style: TextStyle(
              fontSize: 12, 
              color: isCurrentDevice ? const Color(0xFF3A6043) : Colors.grey,
              fontWeight: isCurrentDevice ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      trailing: isCurrentDevice
          ? null
          : IconButton(
              icon: const Icon(Icons.logout, color: Color(0xFFD32F2F), size: 20),
              onPressed: onLogout,
            ),
    );
  }

}
