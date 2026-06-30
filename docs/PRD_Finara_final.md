# PRODUCT REQUIREMENT DOCUMENT

# Finara

*Aplikasi Pencatat Keuangan Berbasis Wallet*

| **Versi Dokumen** | v1.2.0 |
|---|---|
| **Tanggal Dibuat** | 23 Juni 2026 |
| **Tanggal Revisi Terakhir** | 26 Juni 2026 — Revisi Fitur Catatan, Notifikasi Kustom, Navigasi FAB, Home Page, dan Model Premium |
| **Status** | Draft — Awaiting Review |
| **Platform Target** | Mobile (Android & iOS) |
| **Bahasa Aplikasi** | Bahasa Indonesia |

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

| **Segmen** | **Deskripsi** | **Kebutuhan Utama** |
|---|---|---|
| Pelajar / Mahasiswa | Usia 17-24, baru mulai mengelola uang sendiri | Catatan sederhana, budget ketat |
| Pekerja Muda | Usia 22-35, ingin mengontrol pengeluaran bulanan | Analisis pengeluaran, export data |
| Ibu Rumah Tangga | Mengelola keuangan keluarga sehari-hari | Multi-wallet, kategorisasi jelas |
| Freelancer | Pemasukan tidak tetap, butuh monitoring cashflow | Grafik tren, laporan periodik |

### 1.5 Cakupan & Batasan Versi 1.0

Versi 1.0 mencakup fitur inti sebagai berikut:

- Dashboard home dengan ringkasan keuangan
- Manajemen catatan (pemasukan & pengeluaran)
- Grafik & analisis cashflow
- Manajemen profil & keamanan akun
- Navigasi bottom navbar dengan aksi cepat

Fitur di luar cakupan v1.0:

- Sinkronisasi rekening bank / e-wallet otomatis
- Fitur perencanaan budget / tabungan tujuan
- Multi-user / berbagi wallet dengan orang lain
- Koneksi dengan platform investasi

*Catatan: tim dev sedang merencanakan model monetisasi Freemium & Premium (pembatasan jumlah wallet dan fitur ekspor data) untuk dirilis pada fase berikutnya — lihat Bagian 13 Model Monetisasi: Freemium & Premium untuk detail lengkap.*

---

## 2. Arsitektur Informasi & Navigasi

### 2.1 Struktur Navigasi Utama

Finara menggunakan bottom navigation bar dengan 5 elemen yang terdiri dari 4 tab utama dan 1 tombol aksi utama (FAB) di tengah. Struktur navbar mengadopsi desain khas dengan bentuk cekungan di tengah yang memberikan kesan modern dan fungsional.

### 2.2 Tata Letak Bottom Navbar

| **Posisi** | **Label** | **Ikon** | **Fungsi** |
|---|---|---|---|
| Kiri 1 | Home | Rumah | Menuju Dashboard Home |
| Kiri 2 | Catatan | Buku/Daftar | Menuju halaman daftar catatan |
| Tengah | + | Plus (FAB) | Aksi cepat: **tambah catatan saja** |
| Kanan 1 | Statistik | Grafik/Chart | Menuju halaman grafik & analisis |
| Kanan 2 | Profil | Orang/Avatar | Menuju halaman profil pengguna |

### 2.3 Perilaku Tombol FAB (+)

Tombol FAB di tengah navbar kini **hanya melayani satu aksi**: menambah catatan baru.

- Tekan FAB → langsung mengarahkan ke halaman Create Catatan (tidak ada speed-dial atau bottom sheet pilihan)

Aksi tambah wallet **dipindahkan ke halaman Home** melalui area card total saldo (lihat Bagian 3.2.1).

*Alasan perubahan: menyederhanakan navigasi agar FAB memiliki satu fungsi yang jelas dan konsisten, serta mendekatkan aksi manajemen wallet ke konteks saldo yang relevan di halaman Home.*

---

## 3. Fitur — Dashboard Home

### 3.1 Deskripsi Fitur

Dashboard Home adalah halaman pertama yang dilihat pengguna setelah login. Halaman ini memberikan gambaran cepat dan menyeluruh mengenai kondisi keuangan pengguna saat ini, termasuk saldo, tren pengeluaran, dan ringkasan aktivitas terbaru.

### 3.2 Elemen-Elemen UI

#### 3.2.1 Card Total Saldo

- Menampilkan total saldo wallet aktif saat ini dalam format Rupiah (Rp)
- Di bawah total saldo, terdapat dua sub-elemen berdampingan yang menggantikan tombol "catatan masuk" dan "catatan keluar" pada versi sebelumnya:
  - **Wallet**: menampilkan nama dan ikon wallet aktif saat ini; tombol ini membuka daftar wallet milik pengguna dan menyediakan opsi **Tambah Wallet** baru
  - **Ganti Wallet**: tombol untuk berpindah ke wallet lain secara cepat, menampilkan daftar wallet yang dimiliki pengguna dalam bentuk bottom sheet
- Card ini menjadi elemen paling menonjol secara visual di halaman home
- Dapat dilengkapi dengan pilihan periode (Hari Ini / Minggu Ini / Bulan Ini)

*Alasan perubahan: mendekatkan manajemen wallet ke konteks saldo agar pengguna dapat langsung menambah atau berpindah wallet dari halaman utama tanpa perlu mengakses menu terpisah.*

#### 3.2.2 Top 3 Spending Kategori

- Menampilkan 3 kategori pengeluaran terbesar pengguna dalam periode aktif
- Setiap item menampilkan: nama kategori, ikon kategori, dan persentase dari total pengeluaran
- Visualisasi dapat berupa progress bar horizontal atau donut chart mini
- Contoh tampilan: Belanja 45% | Makan 30% | Transportasi 25%
- Data diurutkan dari persentase terbesar ke terkecil

#### 3.2.3 Transaksi Terbaru

- Menampilkan 5 catatan transaksi terbaru pengguna
- Setiap item catatan menampilkan: ikon kategori, nama catatan, waktu pencatatan, dan nominal (merah untuk pengeluaran, hijau untuk pemasukan)
- Terdapat tombol "Lihat Semua" di pojok kanan atas yang mengarahkan ke halaman Catatan (Page Catatan)
- Format tampilan mengikuti referensi desain yang diberikan (lihat Image 1)

#### 3.2.4 Insight & Quote Motivasi

- Menampilkan satu kartu insight yang berisi quote atau tips keuangan singkat
- Kartu ini menggunakan desain yang menarik dengan ilustrasi karakter (seperti Image 2)
- Konten dapat bersifat statis (dari kumpulan quote yang dikurasi) atau dinamis berdasarkan pola keuangan pengguna
- Contoh insight: "Amankan masa depanmu! Setiap rupiah yang kamu sisihkan hari ini adalah batu bata untuk ketenangan hidupmu esok hari."
- Konten berganti setiap hari atau setiap kali halaman di-refresh

#### 3.2.5 CTA (Call-to-Action) — Opsional

- Tombol atau banner ajakan bertindak yang bersifat opsional
- Contoh CTA: "Catat Pengeluaran Hari Ini" atau "Mulai Rencanakan Bulan Depan"
- CTA harus relevan dengan konteks keuangan pengguna saat ini
- Tidak wajib ditampilkan jika dashboard sudah terasa penuh

### 3.3 Spesifikasi Teknis

| **Aspek** | **Detail** |
|---|---|
| Sumber Data | Wallet aktif yang dipilih pengguna |
| Periode Default | Bulan berjalan (dapat diubah pengguna) |
| Refresh Data | Real-time saat halaman dibuka / pull-to-refresh |
| Loading State | Skeleton screen untuk setiap card/elemen |
| Empty State | Tampilan khusus jika belum ada catatan sama sekali |

### 3.4 User Stories

Sebagai pengguna, saya ingin:

- Melihat total saldo saya secara langsung saat membuka aplikasi, agar saya tahu kondisi keuangan saya sekarang.
- Melihat 3 kategori pengeluaran terbesar dalam bentuk persentase, agar saya tahu ke mana uang saya paling banyak pergi.
- Mengakses catatan terbaru langsung dari dashboard, agar saya dapat mengecek aktivitas terkini tanpa pindah halaman.
- Membaca insight atau quote keuangan yang menyemangati, agar saya termotivasi untuk terus mencatat keuangan.
- Menambah wallet baru atau berpindah wallet langsung dari halaman home tanpa navigasi tambahan.

---

## 4. Fitur — Halaman Catatan

### 4.1 Deskripsi Fitur

Halaman Catatan adalah pusat aktivitas pencatatan keuangan pengguna. Di sini, pengguna dapat melihat seluruh riwayat catatan keuangannya, melakukan pencarian, pemfilteran, serta mengelola (membaca, mengubah, menghapus) setiap catatan secara individual.

### 4.2 Tipe Catatan yang Didukung

| **Tipe** | **Deskripsi** | **Indikator Warna** |
|---|---|---|
| Pemasukan | Uang yang masuk ke wallet (gaji, bonus, penjualan, dll.) | Hijau (+) |
| Pengeluaran | Uang yang keluar dari wallet (belanja, makan, transport, dll.) | Merah (-) |

### 4.3 Daftar Catatan

#### 4.3.1 Tampilan List

- Seluruh catatan ditampilkan dalam format list yang dapat digulir (scrollable)
- Setiap item catatan menampilkan: ikon kategori, nama catatan, waktu pencatatan, dan nominal
- Catatan dikelompokkan berdasarkan tanggal (grouping by date) dengan header tanggal yang terlihat jelas
- Format header grup tanggal: "Hari ini, 23 Juni 2026" / "Kemarin, 22 Juni 2026" / "20 Juni 2026"

#### 4.3.2 Pembatasan Tampilan Catatan per Hari

Untuk menjaga tampilan list tetap bersih dan tidak terlalu panjang, catatan per hari dibatasi tampilannya:

- Jika pada suatu hari terdapat **lebih dari 3 catatan**, halaman catatan hanya menampilkan **3 catatan pertama** untuk hari tersebut
- Di bawah catatan ketiga, tersedia tombol **"Lihat Selengkapnya (N catatan)"** yang menampilkan jumlah catatan yang tersembunyi
- Menekan tombol tersebut membuka halaman atau modal detail yang menampilkan **seluruh catatan pada hari itu** tanpa batasan
- Jika pada suatu hari hanya ada 3 catatan atau kurang, seluruh catatan ditampilkan langsung tanpa tombol tambahan
- Aturan pembatasan ini berlaku **untuk setiap hari**, baik hari ini maupun hari-hari sebelumnya

Contoh tampilan:

> **Hari ini, 26 Juni 2026**
> [Catatan 1] [Catatan 2] [Catatan 3]
> *Lihat Selengkapnya (2 catatan lainnya)*
>
> **Kemarin, 25 Juni 2026**
> [Catatan 1] [Catatan 2] [Catatan 3]
> *Lihat Selengkapnya (1 catatan lainnya)*

#### 4.3.3 Empty State

- Jika tidak ada catatan sama sekali: tampilkan ilustrasi atau ikon yang relevan dengan pesan "Belum ada catatan. Mulai catat keuanganmu sekarang!"
- Jika hasil pencarian/filter kosong: tampilkan pesan "Catatan tidak ditemukan. Coba ubah kata kunci atau filter."
- Tombol CTA "Tambah Catatan" tersedia di empty state sebagai ajakan bertindak

### 4.4 Fitur Pencarian (Search)

- Search bar tersedia di bagian atas halaman catatan
- Pencarian berdasarkan: nama catatan, kategori, atau jumlah nominal
- Pencarian bersifat real-time (live search saat mengetik)
- Mendukung pencarian parsial (tidak harus kata lengkap)
- Tombol clear (X) tersedia untuk menghapus teks pencarian dengan cepat

### 4.5 Fitur Filter & Sorting

#### 4.5.1 Filter Tersedia

- Berdasarkan Tipe: Semua | Pemasukan | Pengeluaran
- Berdasarkan Kategori: pilih satu atau lebih kategori
- Berdasarkan Rentang Tanggal: tanggal mulai dan tanggal akhir (date range picker)
- Berdasarkan Nominal: rentang nominal minimum dan maksimum

#### 4.5.2 Sorting Tersedia

- Terbaru (default): catatan terbaru ditampilkan paling atas
- Terlama: catatan tertua ditampilkan paling atas
- Nominal Terbesar: dari nominal terbesar ke terkecil
- Nominal Terkecil: dari nominal terkecil ke terbesar

#### 4.5.3 Perilaku Filter & Sorting

- Filter dan sorting dapat dikombinasikan
- Indikator aktif (badge/highlight) menunjukkan filter sedang diterapkan
- Tombol "Reset" tersedia untuk menghapus semua filter sekaligus

### 4.6 Manajemen Catatan (CRUD)

#### 4.6.1 Baca / Lihat Detail (Read)

Saat pengguna menekan salah satu item catatan, muncul modal detail catatan yang berisi:

- Nama catatan (ditampilkan besar/menonjol sebagai highlight utama)
- Tipe catatan: label bertuliskan "Pemasukan" atau "Pengeluaran" dengan warna sesuai
- Nominal: ditampilkan dalam format Rupiah yang jelas (Rp 5.000.000,00)
- Tanggal dicatat: format panjang (22 Juni 2026)
- Waktu: jam pencatatan
- Kategori: nama kategori dengan ikonnya
- Catatan/notes: teks bebas yang diisi pengguna (jika ada)
- Tombol Edit dan Hapus tersedia di dalam modal ini

Contoh data modal catatan:

| **Field** | **Contoh Nilai** |
|---|---|
| Nama Catatan | Gaji |
| Tipe | Pemasukan |
| Nominal | Rp 5.000.000,00 |
| Tanggal Dicatat | 22 Juni 2026 |
| Catatan | Gaji pertamaku niiih. Aku coba sisihin bulan depan buat nyicil utang. |

#### 4.6.2 Ubah / Edit (Update)

- Pengguna dapat mengedit catatan melalui tombol Edit di modal detail
- Halaman edit menampilkan form yang sudah terisi dengan data lama (pre-filled form)
- Semua field yang ada saat membuat catatan dapat diubah
- Setelah berhasil disimpan, pengguna kembali ke halaman catatan dengan data yang sudah diperbarui
- Tampilkan konfirmasi sukses (toast/snackbar) setelah edit berhasil

#### 4.6.3 Hapus (Delete)

- Tombol Hapus tersedia di modal detail catatan
- Sebelum menghapus, tampilkan dialog konfirmasi: "Yakin ingin menghapus catatan ini? Tindakan ini tidak dapat dibatalkan."
- Terdapat dua opsi: "Batal" dan "Hapus"
- Setelah berhasil dihapus, modal tertutup dan list diperbarui secara otomatis
- Tampilkan konfirmasi sukses (toast/snackbar) setelah hapus berhasil

### 4.7 User Stories

- Sebagai pengguna, saya ingin melihat seluruh riwayat catatan keuangan saya yang terorganisir berdasarkan tanggal.
- Sebagai pengguna, saya ingin tampilan catatan tidak terlalu panjang jika ada banyak catatan dalam satu hari, agar saya bisa scroll dengan nyaman.
- Sebagai pengguna, saya ingin ada tombol "Lihat Selengkapnya" jika ada lebih dari 3 catatan pada suatu hari, agar saya tetap bisa mengakses semua catatan jika dibutuhkan.
- Sebagai pengguna, saya ingin mencari catatan tertentu berdasarkan nama agar saya bisa menemukan transaksi spesifik dengan cepat.
- Sebagai pengguna, saya ingin memfilter catatan berdasarkan tipe atau kategori agar saya bisa fokus menganalisis jenis pengeluaran tertentu.
- Sebagai pengguna, saya ingin melihat detail lengkap sebuah catatan termasuk notes yang saya tulis sebelumnya.
- Sebagai pengguna, saya ingin mengedit catatan yang salah input agar data keuangan saya tetap akurat.
- Sebagai pengguna, saya ingin menghapus catatan yang tidak diperlukan dengan konfirmasi terlebih dahulu agar tidak terjadi penghapusan tidak sengaja.

---

## 5. Fitur — Buat Catatan Baru

### 5.1 Deskripsi Fitur

Halaman Create Catatan diakses melalui tombol FAB (+) di navbar. Tombol ini kini langsung membuka halaman Create Catatan tanpa pilihan tambahan. Halaman ini berupa form yang memungkinkan pengguna mencatat transaksi keuangan baru dengan cepat dan mudah.

### 5.2 Field Form Create Catatan

| **Field** | **Tipe Input** | **Wajib** | **Keterangan** |
|---|---|---|---|
| Tipe Catatan | Toggle/Radio | Ya | Pilihan: Pemasukan atau Pengeluaran |
| Kategori | Dropdown/Grid Ikon | Ya | Daftar kategori sesuai tipe catatan |
| Nominal | Number Input | Ya | Format Rupiah, angka saja tanpa separator |
| Nama Catatan | Text Input | Ya | Nama/deskripsi singkat transaksi |
| Catatan/Notes | Textarea | Tidak | Keterangan bebas, maks. 500 karakter |
| Tanggal & Waktu | Date-Time Picker | Ya | Default: waktu saat ini |

### 5.3 Daftar Kategori

#### 5.3.1 Kategori Pengeluaran

- Kuliner / Makanan & Minuman
- Transportasi
- Belanja
- Kesehatan & Obat
- Hiburan
- Pendidikan
- Tagihan & Utilitas (listrik, air, internet)
- Perawatan Diri
- Olahraga
- Sosial (hadiah, donasi, arisan)
- Rumah & Perlengkapan
- Lainnya

#### 5.3.2 Kategori Pemasukan

- Gaji / Upah
- Bonus
- Freelance / Proyek
- Bisnis
- Investasi / Dividen
- Hadiah / Pemberian
- Penjualan Barang
- Lainnya

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

Halaman Statistik menyajikan visualisasi data keuangan pengguna dalam bentuk grafik interaktif. Pengguna dapat memahami tren cashflow, komposisi pengeluaran per kategori, dan pola keuangan mereka dari waktu ke waktu. Nama halaman yang dipilih adalah "Statistik" karena bersifat netral, familiar, dan mudah dipahami oleh segala segmen usia pengguna Indonesia.

### 6.2 Grafik Cashflow Utama

- Menampilkan grafik garis (line chart) atau grafik batang (bar chart) yang memvisualisasikan arus kas pengguna
- Sumbu X: periode waktu (hari / minggu / bulan / tahun)
- Sumbu Y: nominal dalam Rupiah
- Dua data series ditampilkan bersamaan: Pemasukan (hijau) dan Pengeluaran (merah)
- Tooltip interaktif saat pengguna menekan titik pada grafik untuk melihat detail nominal

### 6.3 Kontrol Periode Grafik

| **Periode** | **Granularitas Data** | **Contoh Tampilan** |
|---|---|---|
| Hari | Per jam (6 jam sekali) | Grafik 24 jam hari ini |
| Minggu | Per hari | Sen - Min pekan ini |
| Bulan | Per hari atau mingguan | Tanggal 1 - 30 bulan ini |
| Tahun | Per bulan | Jan - Des tahun ini |

### 6.4 Elemen Tambahan Halaman Statistik

#### 6.4.1 Ringkasan Numerik

- Total Pemasukan periode terpilih
- Total Pengeluaran periode terpilih
- Saldo bersih (pemasukan - pengeluaran) dengan warna positif/negatif

#### 6.4.2 Grafik Komposisi Kategori

- Donut chart atau pie chart yang memecah pengeluaran berdasarkan kategori
- Legenda yang menampilkan nama kategori, persentase, dan nominal total
- Hanya tampilkan data pengeluaran (tidak relevan untuk kategori pemasukan)

#### 6.4.3 Tabel Ringkasan per Kategori

- Tabel yang merangkum total pengeluaran per kategori dalam periode terpilih
- Diurutkan dari pengeluaran terbesar ke terkecil
- Menampilkan: nama kategori, ikon, total nominal, dan persentase dari total pengeluaran

### 6.5 User Stories

- Sebagai pengguna, saya ingin melihat grafik cashflow bulanan saya agar saya tahu di tanggal mana pengeluaran saya paling besar.
- Sebagai pengguna, saya ingin membandingkan pemasukan dan pengeluaran dalam satu grafik agar saya bisa mengevaluasi kondisi keuangan saya.
- Sebagai pengguna, saya ingin mengubah periode grafik dari harian ke tahunan agar saya bisa melihat tren jangka panjang keuangan saya.

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
- Tampilkan status 2FA saat ini (Aktif / Nonaktif) dengan toggle yang jelas
- Saat mengaktifkan: tunjukkan langkah-langkah setup yang jelas
- Saat menonaktifkan: minta konfirmasi dan verifikasi identitas terlebih dahulu

#### 7.3.3 Sesi Aktif (Opsional v1.1)

- Menampilkan daftar perangkat yang sedang login
- Pengguna dapat keluar dari sesi tertentu atau semua sesi sekaligus

### 7.4 Pengaturan Notifikasi

Finara menggunakan sistem notifikasi yang dirancang untuk mendorong kebiasaan pencatatan keuangan harian. Notifikasi dibagi menjadi dua jenis: **notifikasi sistem bawaan** dan **notifikasi pengingat kustom yang dapat dipersonalisasi oleh pengguna**.

#### 7.4.1 Notifikasi Sistem Bawaan

| **Nama Notifikasi** | **Deskripsi** | **Default** |
|---|---|---|
| Pengingat Harian | Ingatkan pengguna untuk mencatat pengeluaran setiap hari di waktu yang ditentukan. Contoh pesan: "Sudahkah kamu mengisi Finara hari ini?" | Aktif (20.00) |
| Ringkasan Mingguan | Kirim ringkasan cashflow setiap akhir pekan (Minggu malam) | Aktif |
| Ringkasan Bulanan | Kirim laporan bulanan setiap tanggal 1 bulan berikutnya | Aktif |
| Pengeluaran Besar | Notifikasi saat pengguna mencatat pengeluaran di atas nominal tertentu (dapat dikustomisasi) | Nonaktif |
| Tips Keuangan | Kirim tips atau insight keuangan mingguan dari Finara | Nonaktif |
| Aktivitas Akun | Notifikasi keamanan: login baru, perubahan password | Aktif (tidak bisa dinonaktifkan) |

#### 7.4.2 Pengingat Kustom

Selain notifikasi sistem bawaan, pengguna dapat membuat **pengingat kustom** yang dipersonalisasi sesuai kebutuhan dan rutinitas keuangan mereka.

**Fitur pengingat kustom:**

- Pengguna dapat membuat satu atau lebih pengingat dengan jadwal, pesan, dan frekuensi yang berbeda-beda
- Setiap pengingat kustom dapat dikonfigurasi dengan:
  - **Nama Pengingat**: label singkat untuk mengidentifikasi pengingat (contoh: "Pengingat Gajian")
  - **Tanggal/Hari Pengiriman**: pilih tanggal tertentu dalam sebulan (1–28) untuk pengingat bulanan, atau hari tertentu dalam seminggu untuk pengingat mingguan
  - **Waktu Pengiriman**: jam dan menit pengiriman notifikasi
  - **Pesan Kustom**: teks notifikasi yang bisa diisi bebas oleh pengguna (maks. 150 karakter)
  - **Frekuensi**: Sekali | Harian | Mingguan | Bulanan
- Pengguna dapat mengaktifkan atau menonaktifkan setiap pengingat kustom secara individual tanpa harus menghapusnya

**Contoh penggunaan:**

- Pengguna gajian setiap tanggal 10 dapat membuat pengingat: Tanggal 10, pukul 09.00, pesan "Hei, udah tanggal gajian nih! Waktunya ngisi Finara yuk 💰"
- Pengguna dengan pengeluaran rutin setiap Senin dapat membuat pengingat mingguan: Setiap Senin, pukul 08.00, pesan "Awal minggu nih, jangan lupa catat pengeluaran kamu!"

**Spesifikasi teknis:**

| **Aspek** | **Detail** |
|---|---|
| Jumlah Pengingat Kustom | Maksimum 5 pengingat aktif per pengguna (v1.0) |
| Penyimpanan | Disimpan di device dan disinkronkan ke server untuk pengguna Premium |
| Izin Notifikasi | Aplikasi meminta izin notifikasi saat pengguna pertama kali mengaktifkan fitur ini |
| Penanganan Izin Ditolak | Tampilkan panduan cara mengaktifkan izin notifikasi dari pengaturan perangkat |

### 7.5 Ekspor Data *(Fitur Premium)*

Fitur ekspor data hanya tersedia untuk pengguna **Premium**.

#### 7.5.1 Ekspor Catatan ke Excel (.xlsx)

- Pengguna Premium dapat mengekspor seluruh catatan keuangan ke format Excel (.xlsx)
- Opsi filter sebelum ekspor: pilih rentang tanggal, tipe catatan, dan/atau kategori
- Kolom yang diekspor: No, Tanggal, Waktu, Nama Catatan, Tipe, Kategori, Nominal, Catatan/Notes
- File diberi nama otomatis: "Finara_Catatan_[TanggalMulai]_[TanggalAkhir].xlsx"

#### 7.5.2 Ekspor Catatan ke PDF (.pdf)

- Pengguna Premium dapat mengekspor seluruh catatan keuangan ke format PDF (.pdf)
- Tampilan PDF mencakup ringkasan saldo, tabel catatan, dan grafik sederhana (opsional)
- Opsi filter sebelum ekspor sama dengan ekspor Excel
- File diberi nama otomatis: "Finara_Catatan_[TanggalMulai]_[TanggalAkhir].pdf"

#### 7.5.3 Ekspor Grafik (Opsional v1.1)

- Pengguna Premium dapat menyimpan grafik statistik sebagai gambar (.png) ke galeri
- Berguna untuk berbagi laporan keuangan dengan orang lain

### 7.6 Opsi Lainnya

- Tentang Finara: versi aplikasi, kebijakan privasi, syarat & ketentuan
- Hubungi Dukungan: form atau link untuk menghubungi tim support
- Hapus Akun: fitur menghapus akun dan seluruh data permanen (dengan multi-konfirmasi)
- Keluar (Logout): tombol logout dengan konfirmasi singkat

---

## 8. Fitur — Manajemen Wallet

### 8.1 Deskripsi Fitur

Sistem wallet adalah fondasi utama dari Finara. Setiap pengguna dapat memiliki lebih dari satu wallet, dan setiap wallet berfungsi sebagai wadah untuk mengelompokkan catatan keuangan. Misalnya, pengguna bisa memiliki wallet "Keuangan Pribadi", "Bisnis Sampingan", dan "Dana Darurat".

### 8.2 Fitur Create Wallet

- Diakses melalui tombol **Wallet** di card total saldo halaman Home (bukan lagi melalui FAB)
- Field form: Nama Wallet (wajib), Ikon Wallet (pilih dari koleksi ikon), Warna Wallet (pilih dari palet warna)
- Saldo awal: pengguna dapat memasukkan saldo awal wallet (opsional, default 0)
- Pengguna Freemium dibatasi hanya 1 wallet aktif; untuk menambah wallet lebih dari 1, pengguna wajib upgrade ke Premium
- Pengguna Premium dapat memiliki maksimum 10 wallet aktif (batas v1.0) — lihat Bagian 13.2 Batasan Multi-Wallet untuk detail lengkap

### 8.3 Pemilihan Wallet Aktif (Switch Wallet)

- Pengguna dapat berpindah antara wallet melalui tombol **Ganti Wallet** di card total saldo halaman Home
- Menekan tombol "Ganti Wallet" memunculkan bottom sheet berisi daftar semua wallet milik pengguna
- Wallet aktif menentukan data yang ditampilkan di seluruh halaman (dashboard, catatan, statistik)
- Opsi "Semua Wallet" untuk menampilkan agregat dari seluruh wallet

---

## 9. Persyaratan Non-Fungsional

### 9.1 Performa

- Waktu muat halaman utama: < 2 detik pada koneksi 4G
- Animasi dan transisi halaman berjalan mulus di 60fps
- Pencarian catatan menampilkan hasil dalam < 300ms
- Grafik statistik selesai di-render dalam < 1.5 detik

### 9.2 Keamanan

- Data pengguna dienkripsi saat transit (HTTPS / TLS 1.2+)
- Data sensitif (password) disimpan dalam bentuk hash (bcrypt)
- Sesi login menggunakan JWT dengan masa berlaku 7 hari
- Mendukung autentikasi dua faktor (2FA) via OTP email
- Input form divalidasi di sisi client dan server untuk mencegah injeksi

### 9.3 Aksesibilitas

- Mendukung ukuran font dinamis (Dynamic Type di iOS, Text Scaling di Android)
- Kontras warna memenuhi standar WCAG 2.1 Level AA
- Semua tombol interaktif memiliki ukuran sentuhan minimal 44x44pt
- Label aksesibilitas (accessibility label) tersedia untuk semua ikon dan gambar

### 9.4 Kompatibilitas Platform

| **Platform** | **Versi Minimum** | **Catatan** |
|---|---|---|
| Android | Android 8.0 (API Level 26) | Target SDK: Android 14 |
| iOS | iOS 14.0 | Target: iOS 17+ |

### 9.5 Offline Capability

- Pengguna dapat melihat data yang sudah di-cache saat offline
- Penambahan catatan saat offline disimpan lokal dan di-sync saat kembali online
- Seluruh catatan keuangan pengguna — baik Freemium maupun Premium — disimpan di database (cloud); tidak ada perbedaan strategi penyimpanan antar tier — lihat Bagian 13.3 Penyimpanan Data untuk detail lengkap
- Indikator status koneksi tersedia di UI jika pengguna sedang offline

---

## 10. Panduan Desain & UX

### 10.1 Bahasa Visual

- Palet warna utama: Hijau (merepresentasikan pertumbuhan, keuangan sehat, kepercayaan)
- Tipografi: Sans-serif modern yang mudah dibaca (Inter, Poppins, atau Plus Jakarta Sans)
- Ilustrasi: karakter orang dengan gaya semi-flat illustration untuk insight dan empty state
- Ikon: konsisten menggunakan satu set ikon (misalnya Phosphor Icons atau Lucide Icons)

### 10.2 Prinsip UX

- Simplicity First: UI tidak membebani pengguna dengan terlalu banyak informasi sekaligus
- Progressive Disclosure: tampilkan informasi dasar dulu, detail tersedia jika diperlukan (contoh: modal detail, tombol "Lihat Selengkapnya")
- Feedback Langsung: setiap aksi pengguna mendapat respons visual segera (loading, sukses, error)
- Micro-interactions: animasi kecil yang membuat pengalaman terasa lebih hidup dan responsif
- Error Prevention: validasi real-time dan konfirmasi sebelum aksi destruktif (hapus)

### 10.3 Tone & Voice

Komunikasi di dalam aplikasi (teks UI, empty state, notifikasi) menggunakan:

- Bahasa: Indonesia yang kasual dan ramah, tidak kaku
- Nada: Mendukung, positif, tidak menghakimi (terutama soal kondisi keuangan pengguna)
- Contoh notifikasi: "Sudahkah kamu mengisi Finara hari ini?" atau "Hei, udah tanggal gajian nih, waktunya ngisi yuk! 💰"
- Contoh empty state: "Belum ada catatan. Ayo mulai catat keuanganmu hari ini!" (bukan "Data kosong")

---

## 11. Alur Pengguna Utama (User Flow)

### 11.1 Alur Onboarding

- Pengguna membuka aplikasi Finara untuk pertama kali
- Tampil halaman splash screen dengan logo dan nama Finara
- Halaman Welcome dengan CTA "Daftar" dan "Masuk"
- Jika daftar: isi nama, email, password > verifikasi email > buat wallet pertama > masuk ke dashboard
- Jika masuk: isi email & password (atau SSO) > masuk ke dashboard

### 11.2 Alur Tambah Catatan

- Pengguna menekan tombol FAB (+) di navbar bawah
- Halaman Create Catatan langsung terbuka (tidak ada pilihan tambahan)
- Pilih tipe catatan: Pemasukan atau Pengeluaran
- Pilih kategori dari grid ikon yang tersedia
- Isi nominal, nama catatan, dan catatan/notes (opsional)
- Periksa atau ubah tanggal & waktu pencatatan
- Tekan "Simpan" > catatan tersimpan > kembali ke halaman sebelumnya
- Notifikasi toast sukses muncul di bagian atas layar

### 11.3 Alur Lihat & Edit Catatan

- Pengguna membuka halaman Catatan
- Scroll atau cari catatan yang ingin dilihat
- Jika ada lebih dari 3 catatan pada suatu hari, tekan "Lihat Selengkapnya" untuk melihat semua catatan hari itu
- Tekan item catatan > modal detail catatan muncul
- Baca seluruh detail catatan
- Jika ingin edit: tekan tombol "Edit" > halaman edit terbuka dengan data pre-filled
- Ubah data yang diperlukan > tekan "Simpan"
- Data berhasil diperbarui > kembali ke halaman catatan

### 11.4 Alur Tambah / Ganti Wallet

- Pengguna membuka halaman Home
- Pada card total saldo, tekan tombol **Wallet** untuk melihat daftar wallet dan menambah wallet baru, atau tekan **Ganti Wallet** untuk berpindah ke wallet lain
- Jika Freemium dan mencoba menambah wallet kedua: tampilkan paywall / upsell screen ke Premium
- Jika Premium: isi form Create Wallet > simpan > wallet baru aktif

### 11.5 Alur Atur Pengingat Kustom

- Pengguna membuka halaman Profil > Pengaturan Notifikasi
- Scroll ke bagian Pengingat Kustom > tekan "Tambah Pengingat"
- Isi nama pengingat, tanggal/hari, waktu, pesan kustom, dan frekuensi
- Tekan "Simpan" > pengingat aktif dan terdaftar
- Pengguna dapat mengaktifkan/menonaktifkan atau menghapus pengingat dari daftar yang ada

---

## 12. Peta Jalan Produk (Roadmap)

| **Fase** | **Target** | **Fitur yang Dikembangkan** |
|---|---|---|
| v1.0 | Q3 2026 | Dashboard Home (dengan Wallet & Ganti Wallet di card saldo), Catatan (CRUD + pembatasan 3 catatan per hari), Create Catatan (FAB langsung ke catatan), Halaman Statistik, Profil & Keamanan, Notifikasi Kustom, Manajemen Wallet (dari Home), Bottom Navbar |
| v1.1 | Q4 2026 | Ekspor grafik sebagai gambar, Sesi aktif di pengaturan keamanan, Dukungan SSO (Google / Apple), Model Freemium & Premium (batasan multi-wallet, ekspor data PDF & Excel) |
| v1.2 | Q1 2027 | Fitur perencanaan budget per kategori, Tujuan tabungan (saving goals), Peringatan jika pengeluaran mendekati batas budget |
| v2.0 | Q2 2027 | Multi-user wallet (berbagi wallet), Sinkronisasi rekening bank, Integrasi e-wallet (GoPay, OVO, Dana), Fitur laporan pajak tahunan |

---

## 13. Model Monetisasi: Freemium & Premium

### 13.1 Ikhtisar Model Freemium & Premium

Finara menggunakan model freemium, di mana seluruh fitur inti (pencatatan, dashboard, statistik, profil, notifikasi kustom) tetap dapat diakses gratis oleh semua pengguna. Pembeda utama antara Freemium dan Premium adalah **jumlah wallet aktif** dan **kemampuan ekspor data**.

| **Aspek** | **Freemium** | **Premium** |
|---|---|---|
| Jumlah Wallet Aktif | Maksimum 1 wallet | Maksimum 10 wallet |
| Ekspor Data (Excel & PDF) | Tidak tersedia | Tersedia |
| Penyimpanan Catatan | Database (cloud) | Database (cloud) |
| Akses Multi-Device | Didukung | Didukung |
| Notifikasi Kustom | Tersedia | Tersedia |
| Fitur Statistik | Tersedia penuh | Tersedia penuh |

*Catatan: perbedaan strategi penyimpanan data (local storage vs cloud) yang sebelumnya direncanakan **dihapus**. Baik pengguna Freemium maupun Premium menggunakan database (cloud) sebagai sumber data utama. Ini memastikan semua pengguna mendapatkan keamanan data yang setara.*

### 13.2 Batasan Multi-Wallet (Freemium vs Premium)

- Pengguna Freemium hanya dapat memiliki 1 (satu) wallet aktif, yang dibuat otomatis saat proses onboarding / pendaftaran pertama kali.
- Tombol **Wallet** dan **Tambah Wallet** di halaman Home tetap terlihat untuk pengguna Freemium, namun saat mencoba menambah wallet kedua akan menampilkan paywall / upsell screen yang mengarahkan ke halaman upgrade Premium.
- Pengguna Premium dapat membuat wallet tambahan hingga batas maksimum 10 wallet aktif.
- Jika pengguna Premium melakukan downgrade, wallet tambahan (selain wallet pertama/default) tidak dihapus secara otomatis, namun dikunci (read-only) hingga pengguna upgrade kembali. Wallet pertama tetap dapat diakses penuh.
- Contoh copy upsell yang direkomendasikan: "Mau pisahin keuangan pribadi dan bisnis? Upgrade ke Premium untuk bikin wallet lebih dari satu."

### 13.3 Penyimpanan Data

Seluruh catatan keuangan pengguna — baik Freemium maupun Premium — disimpan di **database cloud (server)**. Tidak ada perbedaan strategi penyimpanan antar tier.

- Data tersinkron antar device untuk semua pengguna
- Backup dilakukan otomatis oleh sistem
- Risiko kehilangan data akibat reinstall atau ganti device sangat rendah untuk semua pengguna
- Fondasi data yang tersentralisasi ini membuka jalan untuk fitur multi-user / berbagi wallet pada roadmap v2.0

*Perubahan dari desain sebelumnya: Freemium tidak lagi menggunakan local storage. Keputusan ini diambil untuk memastikan semua pengguna mendapatkan keamanan dan kenyamanan data yang sama, serta menyederhanakan arsitektur teknis.*

### 13.4 Fitur Premium: Ekspor Data

Fitur ekspor data tersedia eksklusif untuk pengguna **Premium** sebagai salah satu nilai tambah utama:

- **Ekspor ke Excel (.xlsx)**: catatan keuangan dapat diekspor ke format spreadsheet untuk analisis lebih lanjut
- **Ekspor ke PDF (.pdf)**: catatan keuangan dapat diekspor ke format PDF siap cetak / dibagikan

Detail teknis ekspor data tersedia di Bagian 7.5 Ekspor Data.

### 13.5 User Stories

- Sebagai pengguna Freemium, saya ingin tetap bisa mencatat keuangan dengan data yang aman di cloud, agar saya tidak kehilangan data meski ganti HP.
- Sebagai pengguna, saya ingin tahu dengan jelas kapan saya perlu upgrade ke Premium (misalnya saat mencoba menambah wallet kedua atau menggunakan fitur ekspor), agar saya tidak bingung dengan batasan yang ada.
- Sebagai pengguna Premium, saya ingin mengekspor catatan saya ke Excel dan PDF, agar saya bisa menganalisis dan berbagi laporan keuangan dengan mudah.

---

## 14. Tech Stack & Arsitektur Teknis

### 14.1 Frontend

Frontend Finara akan dibangun menggunakan Flutter, framework cross-platform dari Google yang memungkinkan satu basis kode digunakan untuk Android maupun iOS sekaligus — selaras dengan target platform pada Bagian 9.4 Kompatibilitas Platform.

- Bahasa pemrograman: Dart
- Keuntungan: satu codebase untuk Android & iOS, performa mendekati native, serta ekosistem widget yang fleksibel untuk UI custom (cocok untuk desain bottom navbar dengan FAB cekungan pada Bagian 2.2)
- State management: direkomendasikan menggunakan Riverpod atau Bloc; keputusan akhir menyusul dari diskusi tim engineering
- Local cache untuk offline viewing: direkomendasikan menggunakan Drift (berbasis SQLite) atau Hive sebagai cache lokal sementara sebelum sinkronisasi ke server

### 14.2 Backend — Perbandingan Custom Backend vs BaaS

Tim dev masih mempertimbangkan dua pendekatan backend: (1) custom backend menggunakan framework JavaScript, atau (2) Backend-as-a-Service (BaaS) seperti Supabase atau Firebase. Tabel berikut merangkum perbandingannya untuk membantu pengambilan keputusan.

| **Aspek** | **Custom Backend (Node.js + PostgreSQL/MySQL)** | **BaaS (Supabase / Firebase)** |
|---|---|---|
| Kecepatan Development | Lebih lambat — API, autentikasi, dan infrastruktur dibangun dari nol | Lebih cepat — autentikasi, database, storage, dan API sudah tersedia out-of-the-box |
| Kontrol & Fleksibilitas | Tinggi — bebas mendesain skema database dan logika bisnis | Sedang — mengikuti fitur dan konvensi yang disediakan platform |
| Biaya Awal (Fase MVP) | Lebih tinggi — perlu server, DevOps, dan waktu development lebih lama | Lebih rendah — tersedia tier gratis, cocok untuk MVP & tim kecil |
| Biaya di Skala Besar | Lebih dapat diprediksi & dioptimalkan sendiri | Berpotensi lebih mahal jika jumlah pengguna/data tumbuh besar, perlu dipantau |
| Model Database | Bebas memilih PostgreSQL atau MySQL | Supabase: PostgreSQL (relasional). Firebase: Firestore (NoSQL) |
| Kebutuhan Tim | Memerlukan backend engineer dedicated | Dapat dikerjakan oleh tim kecil / tim yang frontend-heavy |
| Kesesuaian Data Finansial | Sangat sesuai — data wallet, catatan, dan kategori bersifat relasional | Supabase sesuai (PostgreSQL relasional); Firebase kurang ideal untuk query relasional/agregasi kompleks |

### 14.3 Rekomendasi Tim & Pertimbangan

Berdasarkan kebutuhan Finara — terutama struktur data yang relasional (wallet, catatan, kategori) dan kebutuhan rilis cepat untuk tim yang masih kecil — rekomendasi awal adalah memulai dengan Supabase sebagai BaaS, dengan opsi migrasi ke custom backend di kemudian hari jika kebutuhan semakin kompleks.

- Supabase menggunakan PostgreSQL di baliknya, sehingga jika di masa depan tim memutuskan pindah ke custom backend, skema data tetap relasional dan migrasinya lebih mudah dibandingkan harus migrasi dari database NoSQL seperti Firestore di Firebase.
- Supabase sudah menyediakan Authentication, Realtime sync, dan Storage bawaan — mengurangi waktu development untuk fitur 2FA (Bagian 7.3.2), sinkronisasi data semua pengguna (Bagian 13.3), dan ekspor data Premium (Bagian 7.5).
- Firebase tetap menjadi alternatif yang valid jika tim memprioritaskan ekosistem Google yang lebih matang dan dokumentasi yang lebih luas, namun model data NoSQL-nya kurang ideal untuk laporan keuangan berbasis kategori dan agregasi seperti pada Bagian 6 Statistik.
- Custom backend (Node.js/NestJS atau Express + PostgreSQL/MySQL) direkomendasikan untuk dipertimbangkan kembali pada fase v2.0, ketika kebutuhan sudah lebih kompleks — misalnya integrasi rekening bank, payment gateway untuk subscription Premium, dan multi-user wallet (lihat Bagian 12 Peta Jalan Produk).
- Disarankan tim tetap menulis kode dengan pola repository/abstraction layer di sisi Flutter, agar perpindahan backend (dari BaaS ke custom) di masa depan tidak memerlukan perubahan besar di sisi frontend.

### 14.4 Database

- Jika memilih jalur BaaS (Supabase): database PostgreSQL sudah disediakan dan dikelola otomatis oleh Supabase, termasuk backup, scaling dasar, dan dashboard pengelolaan data.
- Jika memilih jalur custom backend: database menggunakan PostgreSQL (rekomendasi utama, karena mendukung relasi dan tipe data numerik/desimal yang presisi untuk nominal uang) atau MySQL sebagai alternatif.
- Tipe data nominal uang harus menggunakan tipe numeric/decimal (bukan float), untuk menghindari pembulatan yang tidak akurat pada perhitungan keuangan.

### 14.5 Ringkasan Rekomendasi Tech Stack

| **Layer** | **Pilihan** | **Status** |
|---|---|---|
| Frontend | Flutter (Dart) | Diputuskan |
| Backend | Direkomendasikan: Supabase (BaaS). Alternatif jangka panjang: custom Node.js + PostgreSQL/MySQL | Direkomendasikan, menunggu keputusan final Tech Lead |
| Database | PostgreSQL (baik via Supabase maupun custom backend) — digunakan oleh semua tier pengguna | Direkomendasikan |
| Local Cache | SQLite (Drift) atau Hive, on-device (untuk offline cache sementara) | Direkomendasikan |
| Autentikasi | Supabase Auth (jika BaaS) atau JWT custom (jika custom backend), selaras dengan Bagian 9.2 Keamanan | Mengikuti keputusan backend |

---

## 15. Pertanyaan Terbuka & Keputusan yang Diperlukan

| **#** | **Pertanyaan** | **Status** | **PIC** |
|---|---|---|---|
| 1 | Apakah aplikasi memerlukan autentikasi biometrik (sidik jari / Face ID)? | Belum diputuskan | Product Owner |
| 2 | Berapa batas maksimum karakter untuk nama catatan? | Sementara: 100 karakter | Product Owner |
| 3 | Apakah CTA di dashboard bersifat statis atau dinamis? | Belum diputuskan | Product + Design |
| 4 | Backend & database apa yang akan digunakan? | Direkomendasikan: Supabase (BaaS) — lihat Bagian 14.3; keputusan final menunggu validasi Tech Lead | Tech Lead |
| 5 | Apakah akan ada versi web (web app) dari Finara? | Di luar scope v1.0 | Product Owner |
| 6 | Apakah insight/quote bersifat hardcoded atau dari API? | Sementara: hardcoded v1.0 | Product + Dev |
| 7 | Bagaimana mekanisme pembayaran untuk upgrade ke Premium (in-app purchase via Play Store/App Store, atau payment gateway eksternal)? | Belum diputuskan | Product + Tech Lead |
| 8 | Apakah akan ada periode trial gratis untuk Premium sebelum pengguna membayar? | Belum diputuskan | Product Owner |
| 9 | Berapa batas maksimum pengingat kustom per pengguna? | Sementara: 5 pengingat aktif | Product Owner |
| 10 | Apakah pesan notifikasi kustom perlu dimoderasi atau divalidasi kontennya? | Belum diputuskan | Product + Dev |

---

## 16. Riwayat Revisi Dokumen

| **Versi** | **Tanggal** | **Penulis** | **Ringkasan Perubahan** |
|---|---|---|---|
| v1.0.0 | 23 Juni 2026 | Tim Finara | Pembuatan dokumen PRD awal, mencakup seluruh fitur v1.0 |
| v1.1.0 | 23 Juni 2026 | Tim Finara | Penambahan Bagian 13 (Model Monetisasi: Freemium & Premium) dan Bagian 14 (Tech Stack & Arsitektur Teknis); update batasan wallet, offline capability, roadmap, dan pertanyaan terbuka terkait |
| v1.2.0 | 26 Juni 2026 | Tim Finara | Revisi navigasi FAB (hanya tambah catatan), penambahan Wallet & Ganti Wallet di Home card saldo, pembatasan tampilan 3 catatan per hari dengan tombol "Lihat Selengkapnya", penambahan sistem notifikasi kustom (Bagian 7.4.2), perubahan model Premium menjadi multi-wallet + ekspor data (PDF & Excel), penyeragaman penyimpanan data ke database untuk semua tier, update alur pengguna, roadmap, dan pertanyaan terbuka |

---

*Finara — PRD v1.2.0 | Dokumen ini bersifat confidential dan hanya untuk penggunaan internal tim.*
