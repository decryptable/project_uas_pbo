import '../exception/data_tidak_valid_exception.dart';
import '../util/format_rupiah.dart';

abstract class Kendaraan {
  Kendaraan({
    required String nama,
    required String platNomor,
    required double hargaSewaPerHari,
  }) {
    this.nama = nama;
    this.platNomor = platNomor;
    this.hargaSewaPerHari = hargaSewaPerHari;
  }

  late String _nama;
  late String _platNomor;
  late double _hargaSewaPerHari;
  bool _tersedia = true;

  String get nama => _nama;

  set nama(String nilai) {
    if (nilai.trim().isEmpty) {
      throw const DataTidakValidException('Nama kendaraan tidak boleh kosong.');
    }
    _nama = nilai.trim();
  }

  String get platNomor => _platNomor;

  set platNomor(String nilai) {
    if (nilai.trim().isEmpty) {
      throw const DataTidakValidException('Plat nomor tidak boleh kosong.');
    }
    _platNomor = nilai.trim().toUpperCase();
  }

  double get hargaSewaPerHari => _hargaSewaPerHari;

  set hargaSewaPerHari(double nilai) {
    if (nilai < 0) {
      throw const DataTidakValidException('Harga sewa tidak boleh negatif.');
    }
    _hargaSewaPerHari = nilai;
  }

  bool get tersedia => _tersedia;

  String get jenis;

  void tandaiDisewa() {
    _tersedia = false;
  }

  void tandaiTersedia() {
    _tersedia = true;
  }

  double hitungBiaya(int lamaHari) => _hargaSewaPerHari * lamaHari;

  void tampilkanInfo() {
    final String status = _tersedia ? 'Tersedia' : 'Disewa';
    print(
      '[$jenis] $_nama ($_platNomor) | '
      '${formatRupiah(_hargaSewaPerHari)}/hari | $status',
    );
  }
}
