import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Dark Palette (Terra Finance) ─────────────────────────────────────────────
class _C {
  _C._();
  static const Color bg             = Color(0xFF101411);
  static const Color surfLow        = Color(0xFF181D19);
  static const Color surf           = Color(0xFF1D211E);
  static const Color surfHigh       = Color(0xFF262B27);
  static const Color surfHighest    = Color(0xFF313531);
  static const Color primary        = Color(0xFFB1CEB5);
  static const Color primaryCont    = Color(0xFF344C3A);
  static const Color onPrimary      = Color(0xFF003920);
  static const Color secondary      = Color(0xFFE3C53C);
  static const Color onSurface      = Color(0xFFE1E3DE);
  static const Color onSurfVar      = Color(0xFFC2C8C0);
  static const Color outline        = Color(0xFF424843);
  static const Color error          = Color(0xFFFFB4AB);
  static const Color errorCont      = Color(0xFF93000A);
}

// ─── Model ────────────────────────────────────────────────────────────────────
enum Frekuensi { sekali, harian, mingguan, bulanan }

extension FrekuensiExt on Frekuensi {
  String get label => switch (this) {
        Frekuensi.sekali   => 'Sekali',
        Frekuensi.harian   => 'Harian',
        Frekuensi.mingguan => 'Mingguan',
        Frekuensi.bulanan  => 'Bulanan',
      };

  IconData get icon => switch (this) {
        Frekuensi.sekali   => Icons.looks_one_outlined,
        Frekuensi.harian   => Icons.today_outlined,
        Frekuensi.mingguan => Icons.view_week_outlined,
        Frekuensi.bulanan  => Icons.calendar_month_outlined,
      };
}

class PengingatKustom {
  String id;
  String nama;
  Frekuensi frekuensi;
  int? tanggal;       // 1-28 untuk bulanan
  int? hariMinggu;    // 1=Senin..7=Minggu untuk mingguan
  TimeOfDay waktu;
  String pesan;
  bool aktif;

  PengingatKustom({
    required this.id,
    required this.nama,
    required this.frekuensi,
    this.tanggal,
    this.hariMinggu,
    required this.waktu,
    required this.pesan,
    this.aktif = true,
  });

  String get jadwalLabel {
    switch (frekuensi) {
      case Frekuensi.harian:
        return 'Setiap hari, ${_fmtTime(waktu)}';
      case Frekuensi.mingguan:
        final hari = _namaHari(hariMinggu ?? 1);
        return 'Setiap $hari, ${_fmtTime(waktu)}';
      case Frekuensi.bulanan:
        return 'Tgl ${tanggal ?? 1}, ${_fmtTime(waktu)}';
      case Frekuensi.sekali:
        return 'Satu kali, ${_fmtTime(waktu)}';
    }
  }

  static String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  static String _namaHari(int d) =>
      ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'][d];
}

// ─── Main View ────────────────────────────────────────────────────────────────
class NotifikasiView extends StatefulWidget {
  const NotifikasiView({super.key});

  @override
  State<NotifikasiView> createState() => _NotifikasiViewState();
}

class _NotifikasiViewState extends State<NotifikasiView>
    with SingleTickerProviderStateMixin {
  // ── Sistem toggles ──
  bool _pengingatHarian    = true;
  bool _ringkasanMingguan  = true;
  bool _ringkasanBulanan   = true;
  bool _pengeluaranBesar   = false;
  bool _tipsKeuangan       = false;

  // ── Pengingat kustom ──
  final List<PengingatKustom> _pengingat = [
    PengingatKustom(
      id: '1',
      nama: 'Pengingat Gajian',
      frekuensi: Frekuensi.bulanan,
      tanggal: 25,
      waktu: const TimeOfDay(hour: 9, minute: 0),
      pesan: 'Hei, udah tanggal gajian nih! Waktunya ngisi Finara yuk 💰',
      aktif: true,
    ),
    PengingatKustom(
      id: '2',
      nama: 'Bayar Listrik',
      frekuensi: Frekuensi.bulanan,
      tanggal: 5,
      waktu: const TimeOfDay(hour: 10, minute: 0),
      pesan: 'Jangan lupa bayar tagihan listrik bulan ini!',
      aktif: false,
    ),
  ];

  static const int _maxPengingat = 5;

  late final AnimationController _fabAnim;

  @override
  void initState() {
    super.initState();
    _fabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _fabAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _C.onSurface, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifikasi & Pengingat',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _C.onSurface,
          ),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Sistem Bawaan ──
            _buildSectionHeader(
              icon: Icons.notifications_active_outlined,
              label: 'SISTEM BAWAAN',
            ),
            const SizedBox(height: 12),
            _buildSistemCard(),

            const SizedBox(height: 32),

            // ── Pengingat Kustom ──
            _buildKustomHeader(),
            const SizedBox(height: 14),

            if (_pengingat.isEmpty) _buildEmptyState(),

            ...List.generate(_pengingat.length, (i) {
              final p = _pengingat[i];
              return _PengingatCard(
                key: ValueKey(p.id),
                pengingat: p,
                onToggle: (v) => setState(() => p.aktif = v),
                onEdit: () => _openForm(existing: p),
                onDelete: () => _confirmDelete(p),
              );
            }),

            if (_pengingat.length >= _maxPengingat)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: _buildLimitBanner(),
              ),
          ],
        ),
      ),

      // ── FAB Tambah ──
      floatingActionButton: _pengingat.length < _maxPengingat
          ? ScaleTransition(
              scale: CurvedAnimation(parent: _fabAnim, curve: Curves.elasticOut),
              child: FloatingActionButton.extended(
                onPressed: () => _openForm(),
                backgroundColor: _C.primary,
                foregroundColor: _C.onPrimary,
                icon: const Icon(Icons.add_alarm_rounded),
                label: const Text(
                  'Tambah',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                elevation: 4,
              ),
            )
          : null,
    );
  }

  // ──────────────── Helpers ────────────────

  Widget _buildSectionHeader({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _C.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: _C.onSurfVar,
            letterSpacing: 2.2,
          ),
        ),
      ],
    );
  }

  Widget _buildSistemCard() {
    return Container(
      decoration: BoxDecoration(
        color: _C.surf,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _C.outline.withValues(alpha: 0.30)),
      ),
      child: Column(
        children: [
          _buildToggle(
            title: 'Pengingat Harian',
            subtitle: 'Ingatkan mencatat keuangan setiap hari',
            icon: Icons.alarm_outlined,
            value: _pengingatHarian,
            onChanged: (v) => setState(() => _pengingatHarian = v),
          ),
          _buildDivider(),
          _buildToggle(
            title: 'Ringkasan Mingguan',
            subtitle: 'Ringkasan cashflow tiap akhir pekan',
            icon: Icons.bar_chart_rounded,
            value: _ringkasanMingguan,
            onChanged: (v) => setState(() => _ringkasanMingguan = v),
          ),
          _buildDivider(),
          _buildToggle(
            title: 'Ringkasan Bulanan',
            subtitle: 'Laporan bulanan setiap tanggal 1',
            icon: Icons.calendar_month_outlined,
            value: _ringkasanBulanan,
            onChanged: (v) => setState(() => _ringkasanBulanan = v),
          ),
          _buildDivider(),
          _buildToggle(
            title: 'Pengeluaran Besar',
            subtitle: 'Notifikasi saat mencatat pengeluaran besar',
            icon: Icons.trending_down_rounded,
            value: _pengeluaranBesar,
            onChanged: (v) => setState(() => _pengeluaranBesar = v),
          ),
          _buildDivider(),
          _buildToggle(
            title: 'Tips Keuangan',
            subtitle: 'Insight & tips keuangan mingguan dari Finara',
            icon: Icons.lightbulb_outline_rounded,
            value: _tipsKeuangan,
            onChanged: (v) => setState(() => _tipsKeuangan = v),
          ),
          _buildDivider(),
          _buildToggle(
            title: 'Aktivitas Akun',
            subtitle: 'Login baru & perubahan password — wajib aktif',
            icon: Icons.shield_outlined,
            value: true,
            onChanged: null,
            locked: true,
          ),
        ],
      ),
    );
  }

  Widget _buildToggle({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool>? onChanged,
    bool locked = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: locked
                  ? _C.secondary.withValues(alpha: 0.12)
                  : _C.primaryCont.withValues(alpha: 0.40),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: locked ? _C.secondary : _C.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: locked ? _C.secondary : _C.onSurface,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: _C.onSurfVar,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: locked ? _C.secondary : _C.primary,
              activeTrackColor: locked
                  ? _C.secondary.withValues(alpha: 0.30)
                  : _C.primary.withValues(alpha: 0.30),
              inactiveThumbColor: _C.onSurfVar,
              inactiveTrackColor: _C.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(
        height: 1,
        indent: 66,
        endIndent: 16,
        color: _C.outline.withValues(alpha: 0.35),
      );

  Widget _buildKustomHeader() {
    final aktifCount = _pengingat.where((p) => p.aktif).length;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.add_alert_outlined, size: 16, color: _C.primary),
                  const SizedBox(width: 8),
                  const Text(
                    'PENGINGAT KUSTOM',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _C.onSurfVar,
                      letterSpacing: 2.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Badge counter
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: _C.primaryCont,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_pengingat.length}/$_maxPengingat',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _C.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '$aktifCount pengingat aktif',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: _C.onSurfVar,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: _C.surf,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _C.outline.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _C.primaryCont.withValues(alpha: 0.35),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_none_rounded, size: 32, color: _C.primary),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada pengingat kustom',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _C.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Buat pengingat personal untuk rutinitas\nkeuanganmu. Maksimal 5 pengingat aktif.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: _C.onSurfVar,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLimitBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _C.secondary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.secondary.withValues(alpha: 0.30)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: _C.secondary, size: 18),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Batas maksimum 5 pengingat kustom telah tercapai. Hapus salah satu untuk menambah yang baru.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: _C.secondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────── Actions ────────────────

  void _openForm({PengingatKustom? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PengingatFormSheet(
        existing: existing,
        onSave: (p) {
          setState(() {
            if (existing != null) {
              final idx = _pengingat.indexWhere((e) => e.id == existing.id);
              if (idx != -1) _pengingat[idx] = p;
            } else {
              _pengingat.add(p);
            }
          });
        },
      ),
    );
  }

  void _confirmDelete(PengingatKustom p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _C.surf,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Hapus Pengingat?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: _C.onSurface,
          ),
        ),
        content: Text(
          'Pengingat "${p.nama}" akan dihapus permanen.',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: _C.onSurfVar,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'Inter',
                color: _C.onSurfVar,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() => _pengingat.removeWhere((e) => e.id == p.id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.errorCont,
              foregroundColor: _C.error,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Pengingat Card ───────────────────────────────────────────────────────────
class _PengingatCard extends StatelessWidget {
  final PengingatKustom pengingat;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PengingatCard({
    super.key,
    required this.pengingat,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final p = pengingat;
    return AnimatedOpacity(
      opacity: p.aktif ? 1.0 : 0.55,
      duration: const Duration(milliseconds: 250),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: _C.surf,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: p.aktif
                ? _C.primary.withValues(alpha: 0.25)
                : _C.outline.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 10),
              child: Row(
                children: [
                  // Frekuensi icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: p.aktif
                          ? _C.primaryCont.withValues(alpha: 0.40)
                          : _C.outline.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      p.frekuensi.icon,
                      size: 18,
                      color: p.aktif ? _C.primary : _C.onSurfVar,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.nama,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _C.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded, size: 12, color: _C.onSurfVar),
                            const SizedBox(width: 4),
                            Text(
                              p.jadwalLabel,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: _C.onSurfVar,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Toggle switch
                  Transform.scale(
                    scale: 0.80,
                    child: Switch(
                      value: p.aktif,
                      onChanged: onToggle,
                      activeColor: _C.primary,
                      activeTrackColor: _C.primary.withValues(alpha: 0.30),
                      inactiveThumbColor: _C.onSurfVar,
                      inactiveTrackColor: _C.outline,
                    ),
                  ),
                ],
              ),
            ),

            // ── Pesan ──
            if (p.pesan.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: _C.surfLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.chat_bubble_outline_rounded, size: 14, color: _C.onSurfVar),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          p.pesan,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: _C.onSurfVar,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // ── Actions ──
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 14),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(
                      foregroundColor: _C.primary,
                      textStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline_rounded, size: 14),
                    label: const Text('Hapus'),
                    style: TextButton.styleFrom(
                      foregroundColor: _C.error,
                      textStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Form Sheet ───────────────────────────────────────────────────────────────
class _PengingatFormSheet extends StatefulWidget {
  final PengingatKustom? existing;
  final ValueChanged<PengingatKustom> onSave;

  const _PengingatFormSheet({this.existing, required this.onSave});

  @override
  State<_PengingatFormSheet> createState() => _PengingatFormSheetState();
}

class _PengingatFormSheetState extends State<_PengingatFormSheet> {
  final _namaCtrl = TextEditingController();
  final _pesanCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Frekuensi _frekuensi = Frekuensi.harian;
  int _tanggal = 1;
  int _hariMinggu = 1; // 1 = Senin
  TimeOfDay _waktu = const TimeOfDay(hour: 9, minute: 0);

  static const _hariOptions = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final p = widget.existing!;
      _namaCtrl.text = p.nama;
      _pesanCtrl.text = p.pesan;
      _frekuensi = p.frekuensi;
      _tanggal = p.tanggal ?? 1;
      _hariMinggu = p.hariMinggu ?? 1;
      _waktu = p.waktu;
    }
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _pesanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      decoration: const BoxDecoration(
        color: _C.surfLow,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ──
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: _C.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Title ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: _C.primaryCont.withValues(alpha: 0.50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_alarm_rounded, color: _C.primary, size: 20),
                ),
                const SizedBox(width: 14),
                Text(
                  _isEdit ? 'Edit Pengingat' : 'Pengingat Baru',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _C.onSurface,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Divider(height: 1, color: _C.outline.withValues(alpha: 0.40)),

          // ── Form ──
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 20, 24, bottomInset + bottomPad + 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama
                    _buildFieldLabel('Nama Pengingat'),
                    const SizedBox(height: 8),
                    _buildTextInput(
                      controller: _namaCtrl,
                      hint: 'cth: Pengingat Gajian',
                      maxLength: 40,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 20),

                    // Frekuensi
                    _buildFieldLabel('Frekuensi'),
                    const SizedBox(height: 10),
                    _buildFrekuensiSelector(),
                    const SizedBox(height: 20),

                    // Tanggal/Hari (conditional)
                    if (_frekuensi == Frekuensi.bulanan) ...[
                      _buildFieldLabel('Tanggal (1–28)'),
                      const SizedBox(height: 10),
                      _buildTanggalPicker(),
                      const SizedBox(height: 20),
                    ],
                    if (_frekuensi == Frekuensi.mingguan) ...[
                      _buildFieldLabel('Hari'),
                      const SizedBox(height: 10),
                      _buildHariPicker(),
                      const SizedBox(height: 20),
                    ],

                    // Waktu
                    _buildFieldLabel('Waktu Pengiriman'),
                    const SizedBox(height: 10),
                    _buildWaktuPicker(),
                    const SizedBox(height: 20),

                    // Pesan
                    _buildFieldLabel('Pesan Kustom'),
                    const SizedBox(height: 8),
                    _buildTextInput(
                      controller: _pesanCtrl,
                      hint: 'cth: Waktunya ngisi Finara yuk! 💰',
                      maxLength: 150,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 28),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _C.primary,
                          foregroundColor: _C.onPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _isEdit ? 'Simpan Perubahan' : 'Buat Pengingat',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: _C.onSurfVar,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Form Widgets ──

  Widget _buildFieldLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _C.onSurfVar,
          letterSpacing: 1.2,
        ),
      );

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hint,
    required int maxLength,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: _C.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _C.onSurfVar, fontSize: 13),
        counterStyle: const TextStyle(color: _C.onSurfVar, fontSize: 11),
        filled: true,
        fillColor: _C.surf,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _C.outline.withValues(alpha: 0.50)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _C.outline.withValues(alpha: 0.50)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _C.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _C.error),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildFrekuensiSelector() {
    return Row(
      children: Frekuensi.values.map((f) {
        final selected = f == _frekuensi;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _frekuensi = f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.only(right: f != Frekuensi.values.last ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected ? _C.primaryCont : _C.surf,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? _C.primary.withValues(alpha: 0.60) : _C.outline.withValues(alpha: 0.40),
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    f.icon,
                    size: 18,
                    color: selected ? _C.primary : _C.onSurfVar,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    f.label,
                    style: TextStyle(
                      fontFamily: selected ? 'Poppins' : 'Inter',
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                      color: selected ? _C.primary : _C.onSurfVar,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTanggalPicker() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: _C.surf,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.outline.withValues(alpha: 0.50)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.event_outlined, size: 18, color: _C.onSurfVar),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Tanggal $_tanggal setiap bulan',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: _C.onSurface,
              ),
            ),
          ),
          // Stepper buttons
          _buildStepper(
            onMinus: _tanggal > 1 ? () => setState(() => _tanggal--) : null,
            onPlus: _tanggal < 28 ? () => setState(() => _tanggal++) : null,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildHariPicker() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(7, (i) {
        final selected = _hariMinggu == i + 1;
        return GestureDetector(
          onTap: () => setState(() => _hariMinggu = i + 1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? _C.primaryCont : _C.surf,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? _C.primary.withValues(alpha: 0.60) : _C.outline.withValues(alpha: 0.40),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Text(
              _hariOptions[i],
              style: TextStyle(
                fontFamily: selected ? 'Poppins' : 'Inter',
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? _C.primary : _C.onSurfVar,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildWaktuPicker() {
    final timeStr =
        '${_waktu.hour.toString().padLeft(2, '0')}:${_waktu.minute.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: _pickTime,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: _C.surf,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.outline.withValues(alpha: 0.50)),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time_rounded, size: 18, color: _C.onSurfVar),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                timeStr,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _C.onSurface,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 18, color: _C.onSurfVar),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper({VoidCallback? onMinus, VoidCallback? onPlus}) {
    return Row(
      children: [
        _StepperBtn(icon: Icons.remove, onTap: onMinus),
        const SizedBox(width: 4),
        Text(
          '$_tanggal',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: _C.onSurface,
          ),
        ),
        const SizedBox(width: 4),
        _StepperBtn(icon: Icons.add, onTap: onPlus),
      ],
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _waktu,
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: _C.primary,
            onPrimary: _C.onPrimary,
            surface: _C.surf,
            onSurface: _C.onSurface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _waktu = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final p = PengingatKustom(
      id: widget.existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      nama: _namaCtrl.text.trim(),
      frekuensi: _frekuensi,
      tanggal: _frekuensi == Frekuensi.bulanan ? _tanggal : null,
      hariMinggu: _frekuensi == Frekuensi.mingguan ? _hariMinggu : null,
      waktu: _waktu,
      pesan: _pesanCtrl.text.trim(),
      aktif: widget.existing?.aktif ?? true,
    );

    Navigator.of(context).pop();
    widget.onSave(p);
  }
}

// ─── Stepper Button ───────────────────────────────────────────────────────────
class _StepperBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: enabled ? _C.primaryCont : _C.outline.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? _C.primary : _C.onSurfVar.withValues(alpha: 0.40),
        ),
      ),
    );
  }
}
