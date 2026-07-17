import '../exception/data_tidak_valid_exception.dart';
import '../util/format_rupiah.dart';
import 'kendaraan.dart';

class Mobil extends Kendaraan {
  Mobil({
    required super.nama,
    required super.platNomor,
    required super.hargaSewaPerHari,
    required int jumlahKursi,
  }) {
    this.jumlahKursi = jumlahKursi;
  }

  static const double biayaAsuransiPerHari = 50000;

  late int _jumlahKursi;

  int get jumlahKursi => _jumlahKursi;

  set jumlahKursi(int nilai) {
    if (nilai <= 0) {
      throw const DataTidakValidException('Jumlah kursi harus lebih dari nol.');
    }
    _jumlahKursi = nilai;
  }

  @override
  String get jenis => 'Mobil';

  @override
  double hitungBiaya(int lamaHari) =>
      super.hitungBiaya(lamaHari) + biayaAsuransiPerHari * lamaHari;

  @override
  void tampilkanInfo() {
    super.tampilkanInfo();
    print(
      '  Kursi: $_jumlahKursi | '
      'Asuransi wajib ${formatRupiah(biayaAsuransiPerHari)}/hari',
    );
  }
}
