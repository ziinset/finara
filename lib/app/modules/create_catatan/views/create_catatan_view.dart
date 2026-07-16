import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/catatan_model.dart';
import '../controllers/create_catatan_controller.dart';

class CreateCatatanView extends GetView<CreateCatatanController> {
  const CreateCatatanView({super.key});

  // ─── Warna (sesuai referensi screen.png) ───
  static const _bgColor = Color(0xFF1E201E);
  static const _surfaceColor = Color(0xFF2C2E2C);
  static const _surfaceHighColor = Color(0xFF3A3C3A);
  static const _greenPrimary = Color(0xFF4CAF50);
  static const _greenContainer = Color(0xFF2E7D32);
  static const _textWhite = Color(0xFFEEEEEE);
  static const _textGray = Color(0xFFA0A0A0);
  static const _borderColor = Color(0xFF4A4C4A);
  static const _errorColor = Color(0xFFEF5350);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: _bgColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: _bgColor,
          foregroundColor: _textWhite,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _surfaceColor,
          hintStyle: const TextStyle(color: _textGray, fontSize: 14),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _greenPrimary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _errorColor),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: _textWhite),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'Buat Catatan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _textWhite,
            ),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, thickness: 1, color: _borderColor),
          ),
        ),
        body: _buildBody(context),
        bottomNavigationBar: _buildFooter(),
      ),
    );
  }

  // ─── Body ───
  Widget _buildBody(BuildContext context) {
    return Obx(() {
      // Baca semua reactive values di sini agar Obx bisa track
      final tipe = controller.selectedTipe.value;
      final kategoriSelected = controller.selectedKategori.value;
      final nomError = controller.nominalError.value;
      final nmError = controller.namaError.value;
      final katError = controller.kategoriError.value;
      final dateTime = controller.selectedDateTime.value;
      final isExpense = tipe == TipeCatatan.pengeluaran;
      final kategoriList = controller.currentKategoriList;

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── TIPE CATATAN ───
            _sectionLabel('TIPE CATATAN'),
            const SizedBox(height: 12),
            _buildSegmentedControl(isExpense),

            const SizedBox(height: 32),

            // ─── JUMLAH NOMINAL ───
            Center(
              child: Text(
                'JUMLAH NOMINAL',
                style: _labelStyle(),
              ),
            ),
            const SizedBox(height: 8),
            _buildNominalInput(nomError),

            const SizedBox(height: 32),

            // ─── KATEGORI ───
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionLabel('KATEGORI'),
                Text(
                  'Kelola',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _greenPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildKategoriGrid(kategoriList, kategoriSelected),
            if (katError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(katError,
                    style: const TextStyle(color: _errorColor, fontSize: 12)),
              ),

            const SizedBox(height: 24),

            // ─── NAMA CATATAN ───
            _sectionLabel('NAMA CATATAN'),
            const SizedBox(height: 8),
            TextField(
              controller: controller.namaController,
              onChanged: controller.validateNama,
              maxLength: 100,
              style: const TextStyle(color: _textWhite, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Contoh: Makan Siang',
                errorText: nmError,
                counterText: '',
              ),
            ),

            const SizedBox(height: 24),

            // ─── CATATAN TAMBAHAN ───
            _sectionLabel('CATATAN TAMBAHAN (OPSIONAL)'),
            const SizedBox(height: 8),
            TextField(
              controller: controller.catatanController,
              maxLines: 3,
              maxLength: 500,
              style: const TextStyle(color: _textWhite, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Tambahkan deskripsi detail di sini...',
                counterText: '',
              ),
            ),

            const SizedBox(height: 24),

            // ─── TANGGAL & WAKTU ───
            _sectionLabel('TANGGAL & WAKTU'),
            const SizedBox(height: 8),
            _buildDateTimePicker(context, dateTime),

            const SizedBox(height: 40),
          ],
        ),
      );
    });
  }

  // ─── Footer Simpan Catatan ───
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: const BoxDecoration(
        color: _bgColor,
        border: Border(
          top: BorderSide(color: _borderColor, width: 1),
        ),
      ),
      child: Obx(() {
        final valid = controller.isFormValid;
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: valid ? controller.simpanCatatan : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _greenContainer,
              foregroundColor: Colors.white,
              disabledBackgroundColor: _greenContainer.withValues(alpha: 0.3),
              disabledForegroundColor: Colors.white.withValues(alpha: 0.3),
              shape: const StadiumBorder(),
              elevation: 4,
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            child: const Text('Simpan Catatan'),
          ),
        );
      }),
    );
  }

  // ───────────────────────────────────────────────
  //  Widgets Pembantu
  // ───────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    return Text(text, style: _labelStyle());
  }

  TextStyle _labelStyle() {
    return const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: _textGray,
    );
  }

  // ─── Segmented Control ───
  Widget _buildSegmentedControl(bool isExpense) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _surfaceHighColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Indicator animasi
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment:
                isExpense ? Alignment.centerRight : Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _greenContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Tombol-tombol
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.setTipe(TipeCatatan.pemasukan),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'Pemasukan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            !isExpense ? FontWeight.w700 : FontWeight.w400,
                        color: !isExpense ? Colors.white : _textGray,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.setTipe(TipeCatatan.pengeluaran),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'Pengeluaran',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isExpense ? FontWeight.w700 : FontWeight.w400,
                        color: isExpense ? Colors.white : _textGray,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Nominal Input ───
  Widget _buildNominalInput(String? error) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: error != null ? _errorColor : _textGray,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Rp',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: _textWhite.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: 8),
              IntrinsicWidth(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 40),
                  child: TextField(
                    controller: controller.nominalController,
                    onChanged: controller.validateNominal,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: _textWhite,
                    ),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: _textWhite.withValues(alpha: 0.3),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 6),
          Text(
            error,
            style: const TextStyle(color: _errorColor, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  // ─── Kategori Grid ───
  Widget _buildKategoriGrid(
      List<KategoriItem> list, KategoriItem? selected) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final item = list[i];
        final isActive = selected?.nama == item.nama;
        return GestureDetector(
          onTap: () => controller.setKategori(item),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? _greenContainer : _surfaceHighColor,
                ),
                child: Icon(
                  item.icon,
                  size: 24,
                  color: isActive ? Colors.white : _textGray,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.nama,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? _textWhite : _textGray,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Date Time Picker ───
  Widget _buildDateTimePicker(BuildContext context, DateTime dt) {
    final formatted =
        DateFormat('EEEE, dd MMM yyyy — HH:mm', 'id_ID').format(dt);
    return GestureDetector(
      onTap: () => controller.pickDateTime(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _surfaceColor,
          border: Border.all(color: _borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                color: _greenPrimary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                formatted,
                style: const TextStyle(color: _textWhite, fontSize: 14),
              ),
            ),
            const Icon(Icons.chevron_right, color: _textGray, size: 20),
          ],
        ),
      ),
    );
  }
}
