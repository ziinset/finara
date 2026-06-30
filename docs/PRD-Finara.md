# 💚 Finara — Aplikasi Pencatat Keuangan Berbasis Wallet

> **Product Requirement Document (PRD)**

![Version](https://img.shields.io/badge/Versi-v1.1.0-green)
![Status](https://img.shields.io/badge/Status-Draft%20Awaiting%20Review-yellow)
![Platform](https://img.shields.io/badge/Platform-Android%20%26%20iOS-blue)
![Language](https://img.shields.io/badge/Bahasa-Indonesia-red)

| Atribut | Detail |
|---|---|
| Versi Dokumen | v1.1.0 |
| Tanggal Dibuat | 23 Juni 2026 |
| Terakhir Direvisi | 23 Juni 2026 — Penambahan Model Freemium & Premium dan Tech Stack |
| Status | Draft — Awaiting Review |
| Platform Target | Mobile (Android & iOS) |
| Bahasa Aplikasi | Bahasa Indonesia |

---

## 📋 Daftar Isi

1. [Ikhtisar Produk](#1-ikhtisar-produk)
2. [Arsitektur Informasi & Navigasi](#2-arsitektur-informasi--navigasi)
3. [Fitur — Dashboard Home](#3-fitur--dashboard-home)
4. [Fitur — Halaman Catatan](#4-fitur--halaman-catatan)
5. [Fitur — Buat Catatan Baru](#5-fitur--buat-catatan-baru)
6. [Fitur — Statistik](#6-fitur--statistik)
7. [Fitur — Halaman Profil](#7-fitur--halaman-profil)
8. [Fitur — Manajemen Wallet](#8-fitur--manajemen-wallet)
9. [Persyaratan Non-Fungsional](#9-persyaratan-non-fungsional)
10. [Panduan Desain & UX](#10-panduan-desain--ux)
11. [Alur Pengguna Utama](#11-alur-pengguna-utama-user-flow)
12. [Peta Jalan Produk](#12-peta-jalan-produk-roadmap)
13. [Model Monetisasi: Freemium & Premium](#13-model-monetisasi-freemium--premium)
14. [Tech Stack & Arsitektur Teknis](#14-tech-stack--arsitektur-teknis)
15. [Pertanyaan Terbuka](#15-pertanyaan-terbuka--keputusan-yang-diperlukan)
16. [Riwayat Revisi Dokumen](#16-riwayat-revisi-dokumen)

---

## 1. Ikhtisar Produk

### 1.1 Visi Produk

Finara adalah aplikasi pencatat keuangan pribadi berbasis mobile yang memungkinkan pengguna mengelola keuangan mereka secara lebih terorganisir melalui sistem wallet. Satu wallet dapat menampung berbagai jenis catatan keuangan sehingga pengguna dapat memantau arus kas, pengeluaran, dan pemasukan dalam satu tempat yang terpadu.

### 1.2 Pernyataan Masalah

Banyak pengguna kesulitan melacak keuangan harian karena:

- Tidak ada pencatatan yang konsisten dan terstruktur
- Sulitnya melihat gambaran besar arus kas secara visual
- Tidak ada sistem kategorisasi pengeluaran yang mudah digunakan
- Minimnya insight otomatis yang membantu pengguna memahami pola keuangan mereka

### 1.3 Tujuan Produk

- Menyediakan platform pencatatan keuangan yang sederhana, intuitif, dan menyenangkan
- Membantu pengguna memahami pola pemasukan dan pengeluaran mereka
- Mendorong kebiasaan mencatat keuangan secara rutin melalui UX yang engaging
- Menyediakan analisis visual yang mudah dipahami untuk mendukung pengambilan keputusan finansial

### 1.4 Target Pengguna

| Segmen | Deskripsi | Kebutuhan Utama |
|---|---|---|
| Pelajar / Mahasiswa | Usia 17–24, baru mulai mengelola uang sendiri | Catatan sederhana, budget ketat |
| Pekerja Muda | Usia 22–35, ingin mengontrol pengeluaran bulanan | Analisis pengeluaran, export data |
| Ibu Rumah Tangga | Mengelola keuangan keluarga sehari-hari | Multi-wallet, kategorisasi jelas |
| Freelancer | Pemasukan tidak tetap, butuh monitoring cashflow | Grafik tren, laporan periodik |

### 1.5 Cakupan & Batasan Versi 1.0

**✅ Termasuk dalam v1.0:**

- Dashboard home dengan ringkasan keuangan
- Manajemen catatan (pemasukan & pengeluaran)
- Grafik & analisis cashflow
- Manajemen profil & keamanan akun
- Navigasi bottom navbar dengan aksi cepat

**🚫 Di luar cakupan v1.0:**

- Sinkronisasi rekening bank / e-wallet otomatis
- Fitur perencanaan budget / tabungan tujuan
- Multi-user / berbagi wallet dengan orang lain
- Koneksi dengan platform investasi

> **Catatan:** Tim dev sedang merencanakan model monetisasi Freemium & Premium (pembatasan jumlah wallet serta perbedaan strategi penyimpanan data) untuk dirilis pada fase berikutnya — lihat [Bagian 13](#13-model-monetisasi-freemium--premium) untuk detail lengkap.

---

## 2. Arsitektur Informasi & Navigasi

### 2.1 Struktur Navigasi Utama

Finara menggunakan **bottom navigation bar** dengan 5 elemen yang terdiri dari 4 tab utama dan 1 tombol aksi utama (FAB) di tengah. Struktur navbar mengadopsi desain khas dengan bentuk cekungan di tengah yang memberikan kesan modern dan fungsional.

### 2.2 Tata Letak Bottom Navbar

| Posisi | Label | Ikon | Fungsi |
|---|---|---|---|
| Kiri 1 | Home | Rumah | Menuju Dashboard Home |
| Kiri 2 | Catatan | Buku/Daftar | Menuju halaman daftar catatan |
| Tengah | + | Plus (FAB) | Aksi cepat: tambah catatan / tambah wallet |
| Kanan 1 | Statistik | Grafik/Chart | Menuju halaman grafik & analisis |
| Kanan 2 | Profil | Orang/Avatar | Menuju halaman profil pengguna |

### 2.3 Perilaku Tombol FAB (+)

Saat pengguna menekan tombol FAB, muncul dua opsi dalam bentuk speed-dial atau bottom sheet kecil:

- **Tambah Catatan** → Mengarahkan ke halaman Create Catatan
- **Tambah Wallet** → Mengarahkan ke halaman Create Wallet baru

> Nama halaman grafik yang direkomendasikan: **Statistik** (singkat, familiar, dan umum digunakan di aplikasi keuangan Indonesia).

---

## 3. Fitur — Dashboard Home

### 3.1 Deskripsi Fitur

Dashboard Home adalah halaman pertama yang dilihat pengguna setelah login. Halaman ini memberikan gambaran cepat dan menyeluruh mengenai kondisi keuangan pengguna saat ini, termasuk saldo, tren pengeluaran, dan ringkasan aktivitas terbaru.

### 3.2 Elemen-Elemen UI

#### 3.2.1 Card Total Saldo

- Menampilkan total saldo wallet aktif saat ini dalam format Rupiah (Rp)
- Di bawah total saldo, terdapat dua sub-elemen berdampingan:
  - **Pemasukan:** total pemasukan periode aktif (ditampilkan dengan warna hijau)
  - **Pengeluaran:** total pengeluaran periode aktif (ditampilkan dengan warna merah)
- Card ini menjadi elemen paling menonjol secara visual di halaman home
- Dapat dilengkapi dengan pilihan periode (Hari Ini / Minggu Ini / Bulan Ini)

#### 3.2.2 Top 3 Spending Kategori

- Menampilkan 3 kategori pengeluaran terbesar pengguna dalam periode aktif
- Setiap item menampilkan: nama kategori, ikon kategori, dan persentase dari total pengeluaran
- Visualisasi dapat berupa progress bar horizontal atau donut chart mini
- Contoh tampilan: `Belanja 45% | Makan 30% | Transportasi 25%`
- Data diurutkan dari persentase terbesar ke terkecil

#### 3.2.3 Transaksi Terbaru

- Menampilkan 5 catatan transaksi terbaru pengguna
- Setiap item catatan menampilkan: ikon kategori, nama catatan, waktu pencatatan, dan nominal (merah untuk pengeluaran, hijau untuk pemasukan)
- Terdapat tombol **"Lihat Semua"** di pojok kanan atas yang mengarahkan ke halaman Catatan

#### 3.2.4 Insight & Quote Motivasi

- Menampilkan satu kartu insight yang berisi quote atau tips keuangan singkat
- Konten dapat bersifat statis (dari kumpulan quote yang dikurasi) atau dinamis berdasarkan pola keuangan pengguna
- Contoh insight: *"Amankan masa depanmu! Setiap rupiah yang kamu sisihkan hari ini adalah batu bata untuk ketenangan hidupmu esok hari."*
- Konten berganti setiap hari atau setiap kali halaman di-refresh

#### 3.2.5 CTA (Call-to-Action) — Opsional

- Tombol atau banner ajakan bertindak yang bersifat opsional
- Contoh CTA: *"Catat Pengeluaran Hari Ini"* atau *"Mulai Rencanakan Bulan Depan"*
- CTA harus relevan dengan konteks keuangan pengguna saat ini
- Tidak wajib ditampilkan jika dashboard sudah terasa penuh

### 3.3 Spesifikasi Teknis

| Aspek | Detail |
|---|---|
| Sumber Data | Wallet aktif yang dipilih pengguna |
| Periode Default | Bulan berjalan (dapat diubah pengguna) |
| Refresh Data | Real-time saat halaman dibuka / pull-to-refresh |
| Loading State | Skeleton screen untuk setiap card/elemen |
| Empty State | Tampilan khusus jika belum ada catatan sama sekali |

### 3.4 User Stories

1. Sebagai pengguna, saya ingin melihat total saldo saya secara langsung saat membuka aplikasi, agar saya tahu kondisi keuangan saya sekarang.
2. Sebagai pengguna, saya ingin melihat 3 kategori pengeluaran terbesar dalam bentuk persentase, agar saya tahu ke mana uang saya paling banyak pergi.
3. Sebagai pengguna, saya ingin mengakses catatan terbaru langsung dari dashboard, agar saya dapat mengecek aktivitas terkini tanpa pindah halaman.
4. Sebagai pengguna, saya ingin membaca insight atau quote keuangan yang menyemangati, agar saya termotivasi untuk terus mencatat keuangan.

---

## 4. Fitur — Halaman Catatan

### 4.1 Deskripsi Fitur

Halaman Catatan adalah pusat aktivitas pencatatan keuangan pengguna. Di sini, pengguna dapat melihat seluruh riwayat catatan keuangannya, melakukan pencarian, pemfilteran, serta mengelola (membaca, mengubah, menghapus) setiap catatan secara individual.

### 4.2 Tipe Catatan yang Didukung

| Tipe | Deskripsi | Indikator Warna |
|---|---|---|
| Pemasukan | Uang yang masuk ke wallet (gaji, bonus, penjualan, dll.) | 🟢 Hijau (+) |
| Pengeluaran | Uang yang keluar dari wallet (belanja, makan, transport, dll.) | 🔴 Merah (−) |

### 4.3 Daftar Catatan

#### 4.3.1 Tampilan List

- Seluruh catatan ditampilkan dalam format list yang dapat digulir (scrollable)
- Setiap item catatan menampilkan: ikon kategori, nama catatan, waktu pencatatan, dan nominal
- Catatan dikelompokkan berdasarkan tanggal (**grouping by date**) dengan header tanggal yang terlihat jelas
- Format header grup tanggal: `"Hari ini, 23 Juni 2026"` / `"Kemarin, 22 Juni 2026"` / `"20 Juni 2026"`

#### 4.3.2 Empty State

- Jika tidak ada catatan sama sekali: tampilkan ilustrasi dengan pesan *"Belum ada catatan. Mulai catat keuanganmu sekarang!"*
- Jika hasil pencarian/filter kosong: tampilkan pesan *"Catatan tidak ditemukan. Coba ubah kata kunci atau filter."*
- Tombol CTA **"Tambah Catatan"** tersedia di empty state sebagai ajakan bertindak

### 4.4 Fitur Pencarian (Search)

- Search bar tersedia di bagian atas halaman catatan
- Pencarian berdasarkan: nama catatan, kategori, atau jumlah nominal
- Pencarian bersifat **real-time** (live search saat mengetik)
- Mendukung pencarian parsial (tidak harus kata lengkap)
- Tombol clear (✕) tersedia untuk menghapus teks pencarian dengan cepat

### 4.5 Fitur Filter & Sorting

#### 4.5.1 Filter Tersedia

- **Berdasarkan Tipe:** Semua | Pemasukan | Pengeluaran
- **Berdasarkan Kategori:** pilih satu atau lebih kategori
- **Berdasarkan Rentang Tanggal:** tanggal mulai dan tanggal akhir (date range picker)
- **Berdasarkan Nominal:** rentang nominal minimum dan maksimum

#### 4.5.2 Sorting Tersedia

- **Terbaru** (default): catatan terbaru ditampilkan paling atas
- **Terlama:** catatan tertua ditampilkan paling atas
- **Nominal Terbesar:** dari nominal terbesar ke terkecil
- **Nominal Terkecil:** dari nominal terkecil ke terbesar

#### 4.5.3 Perilaku Filter & Sorting

- Filter dan sorting dapat dikombinasikan
- Indikator aktif (badge/highlight) menunjukkan filter sedang diterapkan
- Tombol **"Reset"** tersedia untuk menghapus semua filter sekaligus

### 4.6 Manajemen Catatan (CRUD)

#### 4.6.1 Baca / Lihat Detail (Read)

Saat pengguna menekan salah satu item catatan, muncul **modal detail catatan** yang berisi:

| Field | Contoh Nilai |
|---|---|
| Nama Catatan | Gaji |
| Tipe | Pemasukan |
| Nominal | Rp 5.000.000,00 |
| Tanggal Dicatat | 22 Juni 2026 |
| Waktu | Jam pencatatan |
| Kategori | Nama kategori + ikon |
| Catatan | Gaji pertamaku niiih. Aku coba sisihin bulan depan buat nyicil utang. |

Tombol **Edit** dan **Hapus** tersedia di dalam modal ini.

#### 4.6.2 Ubah / Edit (Update)

- Pengguna dapat mengedit catatan melalui tombol Edit di modal detail
- Halaman edit menampilkan form yang sudah terisi dengan data lama (**pre-filled form**)
- Semua field yang ada saat membuat catatan dapat diubah
- Setelah berhasil disimpan, pengguna kembali ke halaman catatan dengan data yang sudah diperbarui
- Tampilkan konfirmasi sukses (toast/snackbar) setelah edit berhasil

#### 4.6.3 Hapus (Delete)

- Tombol Hapus tersedia di modal detail catatan
- Sebelum menghapus, tampilkan dialog konfirmasi: *"Yakin ingin menghapus catatan ini? Tindakan ini tidak dapat dibatalkan."*
- Terdapat dua opsi: **"Batal"** dan **"Hapus"**
- Setelah berhasil dihapus, modal tertutup dan list diperbarui secara otomatis
- Tampilkan konfirmasi sukses (toast/snackbar) setelah hapus berhasil

### 4.7 User Stories

1. Sebagai pengguna, saya ingin melihat seluruh riwayat catatan keuangan saya yang terorganisir berdasarkan tanggal.
2. Sebagai pengguna, saya ingin mencari catatan tertentu berdasarkan nama agar saya bisa menemukan transaksi spesifik dengan cepat.
3. Sebagai pengguna, saya ingin memfilter catatan berdasarkan tipe atau kategori agar saya bisa fokus menganalisis jenis pengeluaran tertentu.
4. Sebagai pengguna, saya ingin melihat detail lengkap sebuah catatan termasuk notes yang saya tulis sebelumnya.
5. Sebagai pengguna, saya ingin mengedit catatan yang salah input agar data keuangan saya tetap akurat.
6. Sebagai pengguna, saya ingin menghapus catatan yang tidak diperlukan dengan konfirmasi terlebih dahulu agar tidak terjadi penghapusan tidak sengaja.

---

## 5. Fitur — Buat Catatan Baru

### 5.1 Deskripsi Fitur

Halaman Create Catatan diakses melalui tombol FAB (+) di navbar dan memilih opsi **"Tambah Catatan"**. Halaman ini berupa form yang memungkinkan pengguna mencatat transaksi keuangan baru dengan cepat dan mudah.

### 5.2 Field Form Create Catatan

| Field | Tipe Input | Wajib | Keterangan |
|---|---|---|---|
| Tipe Catatan | Toggle/Radio | ✅ Ya | Pilihan: Pemasukan atau Pengeluaran |
| Kategori | Dropdown/Grid Ikon | ✅ Ya | Daftar kategori sesuai tipe catatan |
| Nominal | Number Input | ✅ Ya | Format Rupiah, angka saja tanpa separator |
| Nama Catatan | Text Input | ✅ Ya | Nama/deskripsi singkat transaksi |
| Catatan/Notes | Textarea | ❌ Tidak | Keterangan bebas, maks. 500 karakter |
| Tanggal & Waktu | Date-Time Picker | ✅ Ya | Default: waktu saat ini |

### 5.3 Daftar Kategori

#### 5.3.1 Kategori Pengeluaran

- 🍽️ Kuliner / Makanan & Minuman
- 🚗 Transportasi
- 🛍️ Belanja
- 💊 Kesehatan & Obat
- 🎮 Hiburan
- 📚 Pendidikan
- 💡 Tagihan & Utilitas (listrik, air, internet)
- 💆 Perawatan Diri
- 🏋️ Olahraga
- 🤝 Sosial (hadiah, donasi, arisan)
- 🏠 Rumah & Perlengkapan
- 📦 Lainnya

#### 5.3.2 Kategori Pemasukan

- 💼 Gaji / Upah
- 🎁 Bonus
- 💻 Freelance / Proyek
- 🏪 Bisnis
- 📈 Investasi / Dividen
- 🎀 Hadiah / Pemberian
- 📦 Penjualan Barang
- 📦 Lainnya

### 5.4 Validasi Form

- Tipe catatan harus dipilih sebelum memilih kategori
- Nominal tidak boleh kosong dan harus lebih dari 0
- Nominal tidak boleh mengandung karakter non-angka
- Nama catatan tidak boleh kosong dan maksimum 100 karakter
- Pesan error ditampilkan di bawah field yang bermasalah
- Tombol simpan tidak aktif (disabled) jika ada field wajib yang belum terisi

---

## 6. Fitur — Statistik

### 6.1 Deskripsi Fitur

Halaman Statistik menyajikan visualisasi data keuangan pengguna dalam bentuk grafik interaktif. Pengguna dapat memahami tren cashflow, komposisi pengeluaran per kategori, dan pola keuangan mereka dari waktu ke waktu.

### 6.2 Grafik Cashflow Utama

- Menampilkan **line chart** atau **bar chart** yang memvisualisasikan arus kas pengguna
- Sumbu X: periode waktu (hari / minggu / bulan / tahun)
- Sumbu Y: nominal dalam Rupiah
- Dua data series ditampilkan bersamaan: **Pemasukan** (hijau) dan **Pengeluaran** (merah)
- Tooltip interaktif saat pengguna menekan titik pada grafik untuk melihat detail nominal

### 6.3 Kontrol Periode Grafik

| Periode | Granularitas Data | Contoh Tampilan |
|---|---|---|
| Hari | Per jam (6 jam sekali) | Grafik 24 jam hari ini |
| Minggu | Per hari | Sen – Min pekan ini |
| Bulan | Per hari atau mingguan | Tanggal 1–30 bulan ini |
| Tahun | Per bulan | Jan – Des tahun ini |

### 6.4 Elemen Tambahan Halaman Statistik

#### 6.4.1 Ringkasan Numerik

- Total Pemasukan periode terpilih
- Total Pengeluaran periode terpilih
- Saldo bersih (pemasukan − pengeluaran) dengan warna positif/negatif

#### 6.4.2 Grafik Komposisi Kategori

- **Donut chart** atau **pie chart** yang memecah pengeluaran berdasarkan kategori
- Legenda yang menampilkan nama kategori, persentase, dan nominal total
- Hanya menampilkan data pengeluaran

#### 6.4.3 Tabel Ringkasan per Kategori

- Tabel yang merangkum total pengeluaran per kategori dalam periode terpilih
- Diurutkan dari pengeluaran terbesar ke terkecil
- Menampilkan: nama kategori, ikon, total nominal, dan persentase dari total pengeluaran

### 6.5 User Stories

1. Sebagai pengguna, saya ingin melihat grafik cashflow bulanan saya agar saya tahu di tanggal mana pengeluaran saya paling besar.
2. Sebagai pengguna, saya ingin membandingkan pemasukan dan pengeluaran dalam satu grafik agar saya bisa mengevaluasi kondisi keuangan saya.
3. Sebagai pengguna, saya ingin mengubah periode grafik dari harian ke tahunan agar saya bisa melihat tren jangka panjang keuangan saya.

---

## 7. Fitur — Halaman Profil

### 7.1 Deskripsi Fitur

Halaman Profil adalah pusat pengaturan akun dan preferensi pengguna. Di sini pengguna dapat mengelola informasi pribadi, keamanan akun, notifikasi, dan melakukan ekspor data.

### 7.2 Informasi Profil

- Foto profil: dapat diubah dari galeri atau kamera
- Nama lengkap
- Nama tampilan (display name)
- Alamat email (read-only jika login dengan Google/Apple)
- Nomor telepon (opsional)
- Tanggal bergabung (informasi saja, tidak dapat diedit)
- Tombol simpan untuk menyimpan perubahan informasi profil

### 7.3 Pengaturan Keamanan

#### 7.3.1 Set / Ubah Password

- Pengguna dapat membuat atau mengubah password akun mereka
- Field: password lama (jika sudah ada), password baru, konfirmasi password baru
- Validasi: minimal 8 karakter, kombinasi huruf dan angka
- Tombol "tampilkan/sembunyikan" password tersedia di setiap field

#### 7.3.2 Two-Factor Authentication (2FA)

- Pengguna dapat mengaktifkan atau menonaktifkan fitur 2FA
- Metode 2FA: OTP via email (wajib) dan/atau authenticator app (opsional)
- Tampilkan status 2FA saat ini (**Aktif** / **Nonaktif**) dengan toggle yang jelas
- Saat mengaktifkan: tunjukkan langkah-langkah setup yang jelas
- Saat menonaktifkan: minta konfirmasi dan verifikasi identitas terlebih dahulu

#### 7.3.3 Sesi Aktif *(Opsional v1.1)*

- Menampilkan daftar perangkat yang sedang login
- Pengguna dapat keluar dari sesi tertentu atau semua sesi sekaligus

### 7.4 Pengaturan Notifikasi

| Nama Notifikasi | Deskripsi | Default |
|---|---|---|
| Pengingat Harian | Ingatkan pengguna untuk mencatat pengeluaran setiap hari di waktu yang ditentukan | Aktif (20.00) |
| Ringkasan Mingguan | Kirim ringkasan cashflow setiap akhir pekan (Minggu malam) | Aktif |
| Ringkasan Bulanan | Kirim laporan bulanan setiap tanggal 1 bulan berikutnya | Aktif |
| Pengeluaran Besar | Notifikasi saat pengguna mencatat pengeluaran di atas nominal tertentu (dapat dikustomisasi) | Nonaktif |
| Tips Keuangan | Kirim tips atau insight keuangan mingguan dari Finara | Nonaktif |
| Aktivitas Akun | Notifikasi keamanan: login baru, perubahan password | Aktif *(tidak bisa dinonaktifkan)* |

### 7.5 Ekspor Data

#### 7.5.1 Ekspor Catatan ke Excel (.xlsx)

- Pengguna dapat mengekspor seluruh catatan keuangan ke format Excel (`.xlsx`)
- Opsi filter sebelum ekspor: pilih rentang tanggal, tipe catatan, dan/atau kategori
- Kolom yang diekspor: No, Tanggal, Waktu, Nama Catatan, Tipe, Kategori, Nominal, Catatan/Notes
- Nama file otomatis: `Finara_Catatan_[TanggalMulai]_[TanggalAkhir].xlsx`

#### 7.5.2 Ekspor Grafik *(Opsional v1.1)*

- Pengguna dapat menyimpan grafik statistik sebagai gambar (`.png`) ke galeri
- Berguna untuk berbagi laporan keuangan dengan orang lain

### 7.6 Opsi Lainnya

- **Tentang Finara:** versi aplikasi, kebijakan privasi, syarat & ketentuan
- **Hubungi Dukungan:** form atau link untuk menghubungi tim support
- **Hapus Akun:** fitur menghapus akun dan seluruh data permanen (dengan multi-konfirmasi)
- **Keluar (Logout):** tombol logout dengan konfirmasi singkat

---

## 8. Fitur — Manajemen Wallet

### 8.1 Deskripsi Fitur

Sistem wallet adalah fondasi utama dari Finara. Setiap pengguna dapat memiliki lebih dari satu wallet, dan setiap wallet berfungsi sebagai wadah untuk mengelompokkan catatan keuangan. Misalnya: wallet *"Keuangan Pribadi"*, *"Bisnis Sampingan"*, dan *"Dana Darurat"*.

### 8.2 Fitur Create Wallet

- Diakses melalui tombol FAB (+) > pilih **"Tambah Wallet"**
- Field form: Nama Wallet (wajib), Ikon Wallet (pilih dari koleksi ikon), Warna Wallet (pilih dari palet warna)
- Saldo awal: pengguna dapat memasukkan saldo awal wallet (opsional, default 0)
- Pengguna **Freemium** dibatasi hanya **1 wallet aktif**; untuk menambah wallet lebih dari 1, pengguna wajib upgrade ke **Premium**
- Pengguna **Premium** dapat memiliki maksimum **10 wallet aktif** (batas v1.0)

> Lihat [Bagian 13.2](#132-batasan-multi-wallet-freemium-vs-premium) untuk detail lengkap batasan multi-wallet.

### 8.3 Pemilihan Wallet Aktif

- Pengguna dapat berpindah antara wallet melalui **selector/switcher** yang tersedia di header Dashboard
- Wallet aktif menentukan data yang ditampilkan di seluruh halaman (dashboard, catatan, statistik)
- Opsi **"Semua Wallet"** untuk menampilkan agregat dari seluruh wallet

---

## 9. Persyaratan Non-Fungsional

### 9.1 Performa

- Waktu muat halaman utama: **< 2 detik** pada koneksi 4G
- Animasi dan transisi halaman berjalan mulus di **60fps**
- Pencarian catatan menampilkan hasil dalam **< 300ms**
- Grafik statistik selesai di-render dalam **< 1.5 detik**

### 9.2 Keamanan

- Data pengguna dienkripsi saat transit (**HTTPS / TLS 1.2+**)
- Data sensitif (password) disimpan dalam bentuk hash (**bcrypt**)
- Sesi login menggunakan **JWT** dengan masa berlaku 7 hari
- Mendukung autentikasi dua faktor (**2FA**) via OTP email
- Input form divalidasi di sisi **client dan server** untuk mencegah injeksi

### 9.3 Aksesibilitas

- Mendukung ukuran font dinamis (Dynamic Type di iOS, Text Scaling di Android)
- Kontras warna memenuhi standar **WCAG 2.1 Level AA**
- Semua tombol interaktif memiliki ukuran sentuhan minimal **44×44pt**
- Label aksesibilitas tersedia untuk semua ikon dan gambar

### 9.4 Kompatibilitas Platform

| Platform | Versi Minimum | Catatan |
|---|---|---|
| Android | Android 8.0 (API Level 26) | Target SDK: Android 14 |
| iOS | iOS 14.0 | Target: iOS 17+ |

### 9.5 Offline Capability

- Pengguna dapat melihat data yang sudah di-cache saat offline
- Penambahan catatan saat offline disimpan lokal dan di-sync saat kembali online *(khusus pengguna Premium)*
- Pengguna **Freemium** menyimpan seluruh catatan secara lokal tanpa sinkronisasi
- Strategi penyimpanan berbeda antar tier — lihat [Bagian 13.3](#133-penyimpanan-data-local-storage-freemium-vs-cloud-database-premium)
- Indikator status koneksi tersedia di UI jika pengguna sedang offline

---

## 10. Panduan Desain & UX

### 10.1 Bahasa Visual

| Elemen | Detail |
|---|---|
| Warna Utama | Hijau (merepresentasikan pertumbuhan, keuangan sehat, kepercayaan) |
| Tipografi | Sans-serif modern: Inter, Poppins, atau Plus Jakarta Sans |
| Ilustrasi | Karakter orang dengan gaya semi-flat illustration |
| Ikon | Konsisten menggunakan satu set ikon (Phosphor Icons atau Lucide Icons) |

### 10.2 Prinsip UX

- **Simplicity First:** UI tidak membebani pengguna dengan terlalu banyak informasi sekaligus
- **Progressive Disclosure:** tampilkan informasi dasar dulu, detail tersedia jika diperlukan (contoh: modal detail)
- **Feedback Langsung:** setiap aksi pengguna mendapat respons visual segera (loading, sukses, error)
- **Micro-interactions:** animasi kecil yang membuat pengalaman terasa lebih hidup dan responsif
- **Error Prevention:** validasi real-time dan konfirmasi sebelum aksi destruktif (hapus)

### 10.3 Tone & Voice

Komunikasi di dalam aplikasi menggunakan:

- **Bahasa:** Indonesia yang kasual dan ramah, tidak kaku
- **Nada:** Mendukung, positif, tidak menghakimi (terutama soal kondisi keuangan pengguna)
- **Contoh:** *"Belum ada catatan. Ayo mulai catat keuanganmu hari ini!"* — bukan *"Data kosong"*

---

## 11. Alur Pengguna Utama (User Flow)

### 11.1 Alur Onboarding

```
Buka Aplikasi
    → Splash Screen
    → Halaman Welcome (Daftar / Masuk)
    
[Daftar]
    → Isi nama, email, password
    → Verifikasi email
    → Buat wallet pertama
    → Masuk ke Dashboard

[Masuk]
    → Isi email & password (atau SSO)
    → Masuk ke Dashboard
```

### 11.2 Alur Tambah Catatan

```
Tekan FAB (+)
    → Muncul opsi: "Tambah Catatan" / "Tambah Wallet"
    → Pilih "Tambah Catatan"
    → Halaman Create Catatan terbuka
    → Pilih tipe: Pemasukan atau Pengeluaran
    → Pilih kategori dari grid ikon
    → Isi nominal, nama catatan, dan catatan/notes (opsional)
    → Periksa / ubah tanggal & waktu
    → Tekan "Simpan"
    → Catatan tersimpan → kembali ke halaman sebelumnya
    → Toast sukses muncul
```

### 11.3 Alur Lihat & Edit Catatan

```
Buka Halaman Catatan
    → Scroll atau cari catatan
    → Tekan item catatan
    → Modal detail muncul → baca detail catatan

[Edit]
    → Tekan "Edit"
    → Halaman edit terbuka dengan data pre-filled
    → Ubah data yang diperlukan → tekan "Simpan"
    → Data diperbarui → kembali ke halaman catatan
```

---

## 12. Peta Jalan Produk (Roadmap)

| Fase | Target | Fitur yang Dikembangkan |
|---|---|---|
| **v1.0** | Q3 2026 | Dashboard Home, Catatan (CRUD), Create Catatan, Halaman Statistik, Profil & Keamanan, Manajemen Wallet, Bottom Navbar |
| **v1.1** | Q4 2026 | Ekspor grafik sebagai gambar, Sesi aktif di pengaturan keamanan, Notifikasi pengeluaran besar yang dapat dikustomisasi, Dukungan SSO (Google / Apple), Model Freemium & Premium |
| **v1.2** | Q1 2027 | Fitur perencanaan budget per kategori, Tujuan tabungan (saving goals), Peringatan jika pengeluaran mendekati batas budget |
| **v2.0** | Q2 2027 | Multi-user wallet (berbagi wallet), Sinkronisasi rekening bank, Integrasi e-wallet (GoPay, OVO, Dana), Fitur laporan pajak tahunan |

---

## 13. Model Monetisasi: Freemium & Premium

### 13.1 Ikhtisar Model Freemium & Premium

Finara menggunakan model **freemium**, di mana seluruh fitur inti (pencatatan, dashboard, statistik, profil) tetap dapat diakses gratis oleh semua pengguna. Beberapa kapabilitas lanjutan dikunci di belakang tier **Premium** (berbayar).

| Aspek | Freemium | Premium |
|---|---|---|
| Jumlah Wallet Aktif | Maksimum **1 wallet** | Maksimum **10 wallet** |
| Penyimpanan Catatan | Local storage di device (offline, tidak tersinkron) | Cloud database (online, tersinkron antar device) |
| Akses Multi-Device | ❌ Tidak didukung | ✅ Didukung |
| Risiko Kehilangan Data | 🔴 Tinggi (hilang jika app di-uninstall / device hilang) | 🟢 Rendah (data tersimpan di server) |
| Backup & Restore | Manual (ekspor file via Bagian 7.5) | Otomatis, real-time ke database |

### 13.2 Batasan Multi-Wallet (Freemium vs Premium)

- Pengguna **Freemium** hanya dapat memiliki **1 (satu) wallet aktif**, yang dibuat otomatis saat proses onboarding.
- Tombol **"Tambah Wallet"** pada FAB tetap terlihat untuk pengguna Freemium, namun saat ditekan akan menampilkan **paywall / upsell screen** yang mengarahkan ke halaman upgrade Premium.
- Pengguna **Premium** dapat membuat wallet tambahan hingga batas maksimum **10 wallet aktif**.
- Jika pengguna Premium melakukan **downgrade**, wallet tambahan (selain wallet pertama) tidak dihapus otomatis, namun dikunci (**read-only**) hingga pengguna upgrade kembali.
- Contoh copy upsell: *"Mau pisahin keuangan pribadi dan bisnis? Upgrade ke Premium untuk bikin wallet lebih dari satu."*

### 13.3 Penyimpanan Data: Local Storage (Freemium) vs Cloud Database (Premium)

#### 13.3.1 Freemium — Local Storage (Offline, Single Device)

- Seluruh catatan keuangan disimpan secara lokal di perangkat pengguna (on-device database, misalnya SQLite/Hive di sisi Flutter)
- Bersifat **offline-first**: aplikasi tetap berfungsi penuh tanpa koneksi internet
- Data terpaku pada **satu device** — jika pengguna login di device lain atau menginstal ulang aplikasi, data tidak akan otomatis muncul
- Tidak ada backup otomatis ke server; pengguna disarankan melakukan ekspor data secara manual (lihat [Bagian 7.5](#75-ekspor-data))

#### 13.3.2 Premium — Cloud Database (Online, Multi-Device)

- Seluruh catatan keuangan disimpan di **database online/cloud**
- Data tersinkron secara **real-time** antar device
- Backup dilakukan **otomatis** oleh sistem; risiko kehilangan data sangat rendah
- Fondasi data yang tersentralisasi ini membuka jalan untuk fitur **multi-user / berbagi wallet** pada roadmap v2.0

### 13.4 Migrasi Data saat Upgrade ke Premium

- Saat pengguna Freemium upgrade ke Premium, seluruh catatan di local storage **diunggah otomatis** ke cloud database
- Tampilkan **progress indicator** selama proses migrasi berlangsung
- Setelah migrasi berhasil, source of truth beralih dari local storage ke cloud database
- Jika migrasi gagal (koneksi terputus), **data lokal tetap aman** dan tidak terhapus; pengguna dapat mencoba migrasi ulang
- Mekanisme teknis migrasi masih perlu didiskusikan lebih lanjut dengan Tech Lead — lihat [Bagian 15](#15-pertanyaan-terbuka--keputusan-yang-diperlukan)

### 13.5 User Stories

1. Sebagai pengguna Freemium, saya ingin tetap bisa mencatat keuangan secara offline tanpa koneksi internet, agar saya bisa mencatat kapan saja dan di mana saja.
2. Sebagai pengguna, saya ingin tahu dengan jelas kapan saya perlu upgrade ke Premium (misalnya saat mencoba menambah wallet kedua), agar saya tidak bingung dengan batasan yang ada.
3. Sebagai pengguna Premium, saya ingin catatan saya otomatis tersinkron saat saya ganti HP, agar saya tidak kehilangan riwayat keuangan yang sudah saya catat.

---

## 14. Tech Stack & Arsitektur Teknis

### 14.1 Frontend

Frontend Finara akan dibangun menggunakan **Flutter**, framework cross-platform dari Google yang memungkinkan satu basis kode digunakan untuk Android maupun iOS.

| Aspek | Detail |
|---|---|
| Bahasa Pemrograman | Dart |
| Framework | Flutter (cross-platform Android & iOS) |
| State Management | Riverpod atau Bloc *(keputusan final dari tim engineering)* |
| Local Storage (Freemium) | Drift (berbasis SQLite) atau Hive |

**Keuntungan Flutter:**
- Satu codebase untuk Android & iOS
- Performa mendekati native
- Ekosistem widget yang fleksibel untuk UI custom (cocok untuk desain bottom navbar dengan FAB cekungan)

### 14.2 Backend — Perbandingan Custom Backend vs BaaS

| Aspek | Custom Backend (Node.js + PostgreSQL/MySQL) | BaaS (Supabase / Firebase) |
|---|---|---|
| Kecepatan Development | 🔴 Lebih lambat — API, autentikasi, dan infrastruktur dibangun dari nol | 🟢 Lebih cepat — autentikasi, database, storage, dan API sudah out-of-the-box |
| Kontrol & Fleksibilitas | 🟢 Tinggi — bebas mendesain skema database dan logika bisnis | 🟡 Sedang — mengikuti fitur dan konvensi platform |
| Biaya Awal (MVP) | 🔴 Lebih tinggi — perlu server, DevOps, dan waktu development lebih lama | 🟢 Lebih rendah — tersedia tier gratis, cocok untuk MVP & tim kecil |
| Biaya di Skala Besar | 🟢 Lebih dapat diprediksi & dioptimalkan sendiri | 🟡 Berpotensi lebih mahal jika jumlah pengguna/data tumbuh besar |
| Model Database | Bebas memilih PostgreSQL atau MySQL | Supabase: PostgreSQL (relasional). Firebase: Firestore (NoSQL) |
| Kebutuhan Tim | Memerlukan backend engineer dedicated | Dapat dikerjakan oleh tim kecil / frontend-heavy |
| Kesesuaian Data Finansial | 🟢 Sangat sesuai — data relasional | Supabase: 🟢 sesuai. Firebase: 🔴 kurang ideal untuk query relasional/agregasi kompleks |

### 14.3 Rekomendasi Tim & Pertimbangan

> **Rekomendasi awal: Supabase sebagai BaaS**, dengan opsi migrasi ke custom backend di kemudian hari jika kebutuhan semakin kompleks.

**Alasan memilih Supabase:**
- Menggunakan **PostgreSQL** di baliknya — jika di masa depan tim pindah ke custom backend, migrasi lebih mudah dibandingkan dari NoSQL Firestore
- Sudah menyediakan **Authentication, Realtime sync, dan Storage** bawaan — mengurangi waktu development untuk fitur 2FA, sinkronisasi data Premium, dan ekspor data
- Cocok untuk struktur data **relasional** (wallet, catatan, kategori) dan kebutuhan rilis cepat untuk tim kecil

**Catatan tentang Firebase:**
- Tetap menjadi alternatif valid jika tim memprioritaskan ekosistem Google yang lebih matang
- Namun model data **NoSQL-nya kurang ideal** untuk laporan keuangan berbasis kategori dan agregasi

**Rekomendasi untuk v2.0:**
- **Custom backend (Node.js/NestJS atau Express + PostgreSQL/MySQL)** direkomendasikan untuk dipertimbangkan kembali pada fase v2.0, ketika kebutuhan sudah lebih kompleks (integrasi rekening bank, payment gateway, multi-user wallet)
- Disarankan tim menulis kode dengan **pola repository/abstraction layer** di sisi Flutter, agar perpindahan backend di masa depan tidak memerlukan perubahan besar di sisi frontend

### 14.4 Database

- **Jika BaaS (Supabase):** PostgreSQL sudah disediakan dan dikelola otomatis, termasuk backup, scaling dasar, dan dashboard pengelolaan data
- **Jika custom backend:** PostgreSQL (rekomendasi utama) atau MySQL sebagai alternatif
- Tipe data nominal uang **harus menggunakan `numeric`/`decimal`** (bukan `float`), untuk menghindari pembulatan yang tidak akurat pada perhitungan keuangan

### 14.5 Ringkasan Rekomendasi Tech Stack

| Layer | Pilihan | Status |
|---|---|---|
| Frontend | Flutter (Dart) | ✅ Diputuskan |
| Backend | Supabase (BaaS). Alternatif jangka panjang: custom Node.js + PostgreSQL/MySQL | 🟡 Direkomendasikan, menunggu keputusan final Tech Lead |
| Database | PostgreSQL (via Supabase maupun custom backend) | 🟡 Direkomendasikan |
| Local Storage (Freemium) | SQLite (Drift) atau Hive, on-device | 🟡 Direkomendasikan |
| Autentikasi | Supabase Auth (jika BaaS) atau JWT custom (jika custom backend) | Mengikuti keputusan backend |

---

## 15. Pertanyaan Terbuka & Keputusan yang Diperlukan

| # | Pertanyaan | Status | PIC |
|---|---|---|---|
| 1 | Apakah aplikasi memerlukan autentikasi biometrik (sidik jari / Face ID)? | ❓ Belum diputuskan | Product Owner |
| 2 | Berapa batas maksimum karakter untuk nama catatan? | 🟡 Sementara: 100 karakter | Product Owner |
| 3 | Apakah CTA di dashboard bersifat statis atau dinamis? | ❓ Belum diputuskan | Product + Design |
| 4 | Backend & database apa yang akan digunakan? | 🟡 Direkomendasikan: Supabase — keputusan final menunggu validasi Tech Lead | Tech Lead |
| 5 | Apakah akan ada versi web (web app) dari Finara? | 🚫 Di luar scope v1.0 | Product Owner |
| 6 | Apakah insight/quote bersifat hardcoded atau dari API? | 🟡 Sementara: hardcoded v1.0 | Product + Dev |
| 7 | Bagaimana mekanisme pembayaran untuk upgrade ke Premium (in-app purchase atau payment gateway eksternal)? | ❓ Belum diputuskan | Product + Tech Lead |
| 8 | Apakah akan ada periode trial gratis untuk Premium sebelum pengguna membayar? | ❓ Belum diputuskan | Product Owner |

---

## 16. Riwayat Revisi Dokumen

| Versi | Tanggal | Penulis | Ringkasan Perubahan |
|---|---|---|---|
| v1.0.0 | 23 Juni 2026 | Tim Finara | Pembuatan dokumen PRD awal, mencakup seluruh fitur v1.0 |
| v1.1.0 | 23 Juni 2026 | Tim Finara | Penambahan Bagian 13 (Model Monetisasi: Freemium & Premium) dan Bagian 14 (Tech Stack & Arsitektur Teknis); update batasan wallet, offline capability, roadmap, dan pertanyaan terbuka terkait |

---

> 🔒 *Dokumen ini bersifat **confidential** dan hanya untuk penggunaan internal tim Finara.*
