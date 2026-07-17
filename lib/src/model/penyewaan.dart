import '../exception/data_tidak_valid_exception.dart';
import '../util/format_rupiah.dart';
import 'kendaraan.dart';

class Penyewaan {
  Penyewaan({
    required this.kendaraan,
    required String namaPenyewa,
    required int lamaHari,
  }) {
    this.namaPenyewa = namaPenyewa;
    this.lamaHari = lamaHari;
  }

  final Kendaraan kendaraan;

  late String _namaPenyewa;
  late int _lamaHari;

  String get namaPenyewa => _namaPenyewa;

  set namaPenyewa(String nilai) {
    if (nilai.trim().isEmpty) {
      throw const DataTidakValidException('Nama penyewa tidak boleh kosong.');
    }
    _namaPenyewa = nilai.trim();
  }

  int get lamaHari => _lamaHari;

  set lamaHari(int nilai) {
    if (nilai <= 0) {
      throw const DataTidakValidException(
        'Lama sewa harus lebih dari nol hari.',
      );
    }
    _lamaHari = nilai;
  }

  double get totalBiaya => kendaraan.hitungBiaya(_lamaHari);

  void tampilkanInfo() {
    print(
      '$_namaPenyewa menyewa ${kendaraan.nama} (${kendaraan.platNomor}) | '
      '$_lamaHari hari | Total: ${formatRupiah(totalBiaya)}',
    );
  }
}
