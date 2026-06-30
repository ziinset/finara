import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilSayaView extends StatelessWidget {
  const ProfilSayaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBE0),
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: const AssetImage('assets/img/Profile-Picture.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A6043), // primaryGreen
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Form Fields
            _buildTextField(label: 'Nama Lengkap', initialValue: 'Goldi Arasseo'),
            const SizedBox(height: 16),
            _buildTextField(label: 'Nama Tampilan', initialValue: 'Goldi'),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Alamat Email', 
              initialValue: 'loremipsum@gmail.com', 
              readOnly: true,
              hint: '(Terkunci dengan login Google/Apple)'
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Nomor Telepon (Opsional)', 
              initialValue: '081234567890',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Tanggal Bergabung', 
              initialValue: '23 Juni 2026', 
              readOnly: true,
            ),
            
            const SizedBox(height: 40),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.snackbar(
                    'Berhasil', 
                    'Profil berhasil diperbarui',
                    backgroundColor: Colors.white,
                    colorText: const Color(0xFF3A6043),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A6043),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    bool readOnly = false,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF4A3933),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          readOnly: readOnly,
          keyboardType: keyboardType,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: readOnly ? Colors.grey[600] : const Color(0xFF2D2D2D),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly ? Colors.grey[200] : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: hint,
          ),
        ),
      ],
    );
  }
}
