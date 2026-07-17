import 'dart:io';

import '../exception/data_tidak_valid_exception.dart';
import '../model/kendaraan.dart';
import '../model/mobil.dart';
import '../model/motor.dart';
import '../model/penyewaan.dart';
import '../service/penyimpanan_service.dart';
import '../service/rental_service.dart';
import '../util/format_rupiah.dart';

class Menu {
  Menu(this._rental, this._penyimpanan);

  final RentalService _rental;
  final PenyimpananService _penyimpanan;

  Future<void> jalankan() async {
    print('=== Sistem Penyewaan Kendaraan ===');
    bool berjalan = true;
    while (berjalan) {
      _tampilkanPilihan();
      try {
        berjalan = await _prosesPilihan(_bacaTeks('Pilih menu: '));
      } on DataTidakValidException catch (e) {
        print('[GAGAL] ${e.pesan}');
      }
    }
    print('Terima kasih telah menggunakan aplikasi.');
  }

  void _tampilkanPilihan() {
    print('');
    print('1. Lihat semua kendaraan');
    print('2. Lihat kendaraan tersedia');
    print('3. Tambah kendaraan');
    print('4. Sewa kendaraan');
    print('5. Kembalikan kendaraan');
    print('6. Lihat penyewaan aktif');
    print('7. Laporan pendapatan');
    print('8. Simpan data');
    print('0. Keluar');
  }

  Future<bool> _prosesPilihan(String pilihan) async {
    switch (pilihan) {
      case '1':
        _tampilkanDaftar(_rental.semuaKendaraan);
      case '2':
        _tampilkanDaftar(_rental.kendaraanTersedia);
      case '3':
        _tambahKendaraan();
      case '4':
        _sewaKendaraan();
      case '5':
        _kembalikanKendaraan();
      case '6':
        _tampilkanPenyewaanAktif();
      case '7':
        _tampilkanLaporan();
      case '8':
        await _penyimpanan.simpanData(_rental.jumlahData);
      case '0':
        return false;
      default:
        print('Pilihan "$pilihan" tidak dikenal.');
    }
    return true;
  }

  void _tampilkanDaftar(List<Kendaraan> daftar) {
    if (daftar.isEmpty) {
      print('Tidak ada kendaraan.');
      return;
    }
    for (final Kendaraan kendaraan in daftar) {
      kendaraan.tampilkanInfo();
    }
  }

  void _tambahKendaraan() {
    print('Jenis kendaraan: 1) Mobil  2) Motor');
    final String jenis = _bacaTeks('Pilih jenis: ');
    final String nama = _bacaTeks('Nama kendaraan: ');
    final String plat = _bacaTeks('Plat nomor: ');
    final double harga = _bacaDesimal('Harga sewa per hari: ');
    final Kendaraan kendaraan = switch (jenis) {
      '1' => Mobil(
        nama: nama,
        platNomor: plat,
        hargaSewaPerHari: harga,
        jumlahKursi: _bacaAngka('Jumlah kursi: '),
      ),
      '2' => Motor(
        nama: nama,
        platNomor: plat,
        hargaSewaPerHari: harga,
        kapasitasMesin: _bacaAngka('Kapasitas mesin (cc): '),
      ),
      _ => throw const DataTidakValidException(
        'Jenis kendaraan harus 1 atau 2.',
      ),
    };
    _rental.tambahKendaraan(kendaraan);
    print('${kendaraan.jenis} "${kendaraan.nama}" berhasil ditambahkan.');
  }

  void _sewaKendaraan() {
    _tampilkanDaftar(_rental.kendaraanTersedia);
    final Penyewaan penyewaan = _rental.sewaKendaraan(
      platNomor: _bacaTeks('Plat nomor: '),
      namaPenyewa: _bacaTeks('Nama penyewa: '),
      lamaHari: _bacaAngka('Lama sewa (hari): '),
    );
    print('Penyewaan berhasil dicatat:');
    penyewaan.tampilkanInfo();
  }

  void _kembalikanKendaraan() {
    final Penyewaan penyewaan = _rental.kembalikanKendaraan(
      _bacaTeks('Plat nomor yang dikembalikan: '),
    );
    print(
      '${penyewaan.kendaraan.nama} dikembalikan. '
      'Tagihan: ${formatRupiah(penyewaan.totalBiaya)}',
    );
  }

  void _tampilkanPenyewaanAktif() {
    final List<Penyewaan> daftar = _rental.penyewaanAktif;
    if (daftar.isEmpty) {
      print('Tidak ada penyewaan aktif.');
      return;
    }
    for (final Penyewaan penyewaan in daftar) {
      penyewaan.tampilkanInfo();
    }
  }

  void _tampilkanLaporan() {
    final List<String> namaTersedia = _rental.kendaraanTersedia
        .map((Kendaraan k) => k.nama)
        .toList();
    print('Kendaraan tersedia : ${namaTersedia.join(', ')}');
    print('Penyewaan aktif    : ${_rental.penyewaanAktif.length}');
    print('Total pendapatan   : ${formatRupiah(_rental.totalPendapatan)}');
  }

  String _bacaTeks(String label) {
    stdout.write(label);
    return stdin.readLineSync()?.trim() ?? '';
  }

  int _bacaAngka(String label) {
    final String masukan = _bacaTeks(label);
    final int? nilai = int.tryParse(masukan);
    if (nilai == null) {
      throw DataTidakValidException('"$masukan" bukan bilangan bulat.');
    }
    return nilai;
  }

  double _bacaDesimal(String label) {
    final String masukan = _bacaTeks(label);
    final double? nilai = double.tryParse(masukan);
    if (nilai == null) {
      throw DataTidakValidException('"$masukan" bukan angka.');
    }
    return nilai;
  }
}
