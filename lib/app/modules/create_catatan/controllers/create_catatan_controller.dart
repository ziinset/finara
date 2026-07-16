import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/catatan_model.dart';
import '../../catatan/controllers/catatan_controller.dart';

class CreateCatatanController extends GetxController {
  // ─── Form State ───
  final selectedTipe = TipeCatatan.pengeluaran.obs;
  final selectedKategori = Rxn<KategoriItem>();
  final nominalController = TextEditingController();
  final namaController = TextEditingController();
  final catatanController = TextEditingController();
  final selectedDateTime = DateTime.now().obs;

  // ─── Validation ───
  final nominalError = Rxn<String>();
  final namaError = Rxn<String>();
  final kategoriError = Rxn<String>();

  // ─── Computed ───
  List<KategoriItem> get currentKategoriList =>
      selectedTipe.value == TipeCatatan.pengeluaran
          ? kategoriPengeluaran
          : kategoriPemasukan;

  bool get isFormValid =>
      selectedKategori.value != null &&
      nominalController.text.isNotEmpty &&
      double.tryParse(nominalController.text) != null &&
      double.parse(nominalController.text) > 0 &&
      namaController.text.isNotEmpty &&
      namaController.text.length <= 100;

  @override
  void onInit() {
    super.onInit();
    // Default pilih kategori pertama sesuai tipe awal
    selectedKategori.value = currentKategoriList.first;

    // Auto-validate ketika tipe berubah, reset kategori
    ever(selectedTipe, (_) {
      selectedKategori.value = currentKategoriList.first;
      kategoriError.value = null;
    });
  }

  @override
  void onClose() {
    nominalController.dispose();
    namaController.dispose();
    catatanController.dispose();
    super.onClose();
  }

  // ─── Actions ───

  void setTipe(TipeCatatan tipe) {
    selectedTipe.value = tipe;
  }

  void setKategori(KategoriItem item) {
    selectedKategori.value = item;
    kategoriError.value = null;
  }

  void setDateTime(DateTime dt) {
    selectedDateTime.value = dt;
  }

  void validateNominal(String value) {
    if (value.isEmpty) {
      nominalError.value = 'Nominal tidak boleh kosong';
    } else if (double.tryParse(value) == null) {
      nominalError.value = 'Nominal harus berupa angka';
    } else if (double.parse(value) <= 0) {
      nominalError.value = 'Nominal harus lebih dari 0';
    } else {
      nominalError.value = null;
    }
  }

  void validateNama(String value) {
    if (value.isEmpty) {
      namaError.value = 'Nama catatan tidak boleh kosong';
    } else if (value.length > 100) {
      namaError.value = 'Nama catatan maksimal 100 karakter';
    } else {
      namaError.value = null;
    }
  }

  Future<void> pickDateTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF7DDC7A),
              onPrimary: Color(0xFF003909),
              surface: Color(0xFF212521),
              onSurface: Color(0xFFE2E3E1),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate == null) return;
    if (!context.mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime.value),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF7DDC7A),
              onPrimary: Color(0xFF003909),
              surface: Color(0xFF212521),
              onSurface: Color(0xFFE2E3E1),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime == null) return;

    setDateTime(DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    ));
  }

  void simpanCatatan() {
    // Validate all
    validateNominal(nominalController.text);
    validateNama(namaController.text);
    if (selectedKategori.value == null) {
      kategoriError.value = 'Pilih kategori terlebih dahulu';
    }

    if (!isFormValid) return;

    final newCatatan = CatatanModel(
      id: const Uuid().v4(),
      nama: namaController.text.trim(),
      tipe: selectedTipe.value,
      kategori: selectedKategori.value!.nama,
      nominal: double.parse(nominalController.text),
      tanggal: selectedDateTime.value,
      catatan: catatanController.text.trim().isEmpty
          ? null
          : catatanController.text.trim(),
    );

    // Tambahkan ke CatatanController
    final catatanCtrl = Get.find<CatatanController>();
    catatanCtrl.allCatatan.insert(0, newCatatan);
    catatanCtrl.allCatatan.refresh();

    Get.back();

    Get.snackbar(
      'Berhasil',
      'Catatan berhasil disimpan 🎉',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF268630),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }
}
