import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:finara/app/data/models/wallet_model.dart';
import 'package:finara/app/modules/wallet/controllers/wallet_controller.dart';

class CreateWalletView extends StatefulWidget {
  const CreateWalletView({super.key});

  @override
  State<CreateWalletView> createState() => _CreateWalletViewState();
}

class _CreateWalletViewState extends State<CreateWalletView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController(text: '0');
  
  Color _selectedColor = const Color(0xFF3A6043); // Default green
  IconData _selectedIcon = Icons.account_balance_wallet;
  
  final List<Color> _availableColors = [
    const Color(0xFF3A6043), // Primary Green
    const Color(0xFF4A90E2), // Blue
    const Color(0xFFF39C12), // Orange
    const Color(0xFF9B59B6), // Purple
    const Color(0xFFE74C3C), // Red
    const Color(0xFF34495E), // Dark Navy
  ];
  
  final List<IconData> _availableIcons = [
    Icons.account_balance_wallet,
    Icons.credit_card,
    Icons.savings,
    Icons.monetization_on,
    Icons.payments,
    Icons.account_balance,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _saveWallet() {
    if (_formKey.currentState!.validate()) {
      final double balance = double.tryParse(_balanceController.text.replaceAll('.', '')) ?? 0.0;
      
      final newWallet = WalletModel(
        id: const Uuid().v4(),
        name: _nameController.text,
        icon: _selectedIcon,
        color: _selectedColor,
        balance: balance,
        isActive: false, // Default to false
      );
      
      final walletController = Get.find<WalletController>();
      final success = walletController.addWallet(newWallet);
      
      if (success) {
        Get.back();
        Get.snackbar(
          'Sukses', 
          'Wallet berhasil ditambahkan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tambah Wallet', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Preview Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _selectedColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_selectedIcon, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nameController.text.isEmpty ? 'Nama Wallet' : _nameController.text,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rp ${_balanceController.text.isEmpty ? '0' : _balanceController.text}',
                          style: const TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Nama Wallet
            const Text('Nama Wallet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Cth: Tabungan Utama',
                filled: true,
                fillColor: const Color(0xFFF5F7F9),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              onChanged: (_) => setState(() {}),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Nama wallet tidak boleh kosong';
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // Saldo Awal
            const Text('Saldo Awal (Opsional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: 'Rp ',
                filled: true,
                fillColor: const Color(0xFFF5F7F9),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            
            // Warna Wallet
            const Text('Warna Wallet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _availableColors.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
                    ),
                    child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 24) : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            
            // Ikon Wallet
            const Text('Ikon Wallet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _availableIcons.map((icon) {
                final isSelected = _selectedIcon == icon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isSelected ? _selectedColor.withValues(alpha: 0.1) : const Color(0xFFF5F7F9),
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected ? Border.all(color: _selectedColor, width: 2) : null,
                    ),
                    child: Icon(
                      icon, 
                      color: isSelected ? _selectedColor : Colors.grey,
                      size: 28,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            
            // Tombol Simpan
            ElevatedButton(
              onPressed: _saveWallet,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Simpan Wallet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
