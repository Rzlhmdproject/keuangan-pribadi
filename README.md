# Keuangan Pribadi 2026

Website manajemen keuangan pribadi (Rupiah, bahasa Indonesia). Satu file `index.html`, tanpa build, tanpa dependensi.

## Fitur
- Dashboard: arus kas bersih, pemasukan, pengeluaran, tabungan, saldo aktual, savings rate
- Transaksi: tambah, ubah, hapus, cari, filter, ekspor CSV (pemasukan, pengeluaran, transfer)
- Anggaran bulanan dengan status Aman / Waspada / Over Budget
- Rekening: saldo sistem vs saldo aktual, selisih rekonsiliasi
- Target tabungan dengan estimasi bulan
- Laporan bulanan, perbandingan dengan bulan lalu, cetak atau simpan sebagai PDF
- Utang dan cicilan: sisa kewajiban, jatuh tempo, pengingat belum dibayar
- Tren 6 bulan di dashboard, tambah akun baru, cadangan dan pemulihan data (.json)

## Penting: tempat data disimpan
Data disimpan di **localStorage browser**. Artinya data tidak ikut berpindah ke HP atau laptop lain, dan hilang jika
data browser dihapus. Gunakan Pengaturan > Unduh cadangan (.json) secara berkala. Untuk sinkron antar perangkat, langkah berikutnya
adalah menghubungkan Supabase.

## Upload ke GitHub
1. Buat repository baru di github.com (misal `keuangan-pribadi`), pilih Private jika ingin data demo tetap pribadi.
2. Klik "uploading an existing file", seret `index.html` dan `README.md`, lalu Commit changes.

## Deploy ke Vercel
1. Buka vercel.com, login dengan akun GitHub.
2. Add New > Project, pilih repository `keuangan-pribadi`, klik Import.
3. Framework Preset: **Other**. Kosongkan Build Command dan Output Directory.
4. Klik Deploy. Website siap di alamat `nama-proyek.vercel.app`.
