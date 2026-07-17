# Sistem Penyewaan Kendaraan (CLI)

|                 |                                      |
| --------------- | ------------------------------------ |
| **Nama**        | Ichsan Hafizd Al-Fajry               |
| **NIM**         | 251240001657                         |
| **Mata Kuliah** | Pemrograman Berorientasi Objek (UAS) |

## Tema Aplikasi

Aplikasi manajemen **penyewaan kendaraan** berbasis terminal (CLI) yang ditulis dengan Dart.
Pengguna dapat mengelola armada kendaraan (mobil dan motor), mencatat penyewaan,
memproses pengembalian, dan melihat laporan pendapatan melalui menu interaktif.

## Fitur Program

1. Lihat semua kendaraan beserta status ketersediaannya
2. Lihat kendaraan yang tersedia untuk disewa
3. Tambah kendaraan baru (Mobil atau Motor) dengan validasi input
4. Sewa kendaraan (mobil dikenai biaya asuransi, motor mendapat diskon sewa mingguan)
5. Kembalikan kendaraan dan hitung total tagihan
6. Lihat daftar penyewaan aktif
7. Laporan pendapatan dari seluruh penyewaan yang selesai
8. Simpan data (simulasi asinkron dengan `async`/`await`)

## Cara Menjalankan Program

Prasyarat: [Dart SDK](https://dart.dev/get-dart) versi 3.9 atau lebih baru.

```bash
dart pub get
dart run bin/main.dart
```

Menjalankan pengujian:

```bash
dart test
```

## Pemetaan Konsep OOP

| Konsep                | Implementasi                                                                                           |
| --------------------- | ------------------------------------------------------------------------------------------------------ |
| Class & Object        | `Kendaraan`, `Mobil`, `Motor`, `Penyewaan`, `RentalService`, `PenyimpananService`, `Menu`              |
| Encapsulation         | Field privat (`_nama`, `_hargaSewaPerHari`, dll.) dengan getter/setter tervalidasi di `lib/src/model/` |
| Inheritance           | `Mobil` dan `Motor` mewarisi class abstrak `Kendaraan`                                                 |
| Polymorphism          | Override `tampilkanInfo()` dan `hitungBiaya()`; objek turunan disimpan dalam `List<Kendaraan>`         |
| Collection            | `List<Kendaraan>`, `Map<String, Penyewaan>`, `List<Penyewaan>` di `RentalService`                      |
| Higher Order Function | `.where()`, `.any()`, `.fold()`, `.map()` di `RentalService` dan `Menu`                                |
| Custom Exception      | `DataTidakValidException` + `try`-`catch` pada loop menu                                               |
| Async/Await           | `PenyimpananService.simpanData()` dengan `Future.delayed` 2 detik                                      |

## Struktur Proyek

```
bin/main.dart                  titik masuk aplikasi
lib/src/model/                 Kendaraan, Mobil, Motor, Penyewaan
lib/src/service/               RentalService, PenyimpananService
lib/src/cli/menu.dart          menu interaktif
lib/src/exception/             DataTidakValidException
lib/src/util/                  formatRupiah
test/                          pengujian unit
```
