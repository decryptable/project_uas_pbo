import '../exception/data_tidak_valid_exception.dart';
import 'kendaraan.dart';

class Motor extends Kendaraan {
  Motor({
    required super.nama,
    required super.platNomor,
    required super.hargaSewaPerHari,
    required int kapasitasMesin,
  }) {
    this.kapasitasMesin = kapasitasMesin;
  }

  static const int minimalHariDiskon = 7;
  static const double persenDiskon = 0.1;

  late int _kapasitasMesin;

  int get kapasitasMesin => _kapasitasMesin;

  set kapasitasMesin(int nilai) {
    if (nilai <= 0) {
      throw const DataTidakValidException(
        'Kapasitas mesin harus lebih dari nol.',
      );
    }
    _kapasitasMesin = nilai;
  }

  @override
  String get jenis => 'Motor';

  @override
  double hitungBiaya(int lamaHari) {
    final double biayaDasar = super.hitungBiaya(lamaHari);
    if (lamaHari >= minimalHariDiskon) {
      return biayaDasar * (1 - persenDiskon);
    }
    return biayaDasar;
  }

  @override
  void tampilkanInfo() {
    super.tampilkanInfo();
    print(
      '  Mesin: $_kapasitasMesin cc | '
      'Diskon ${(persenDiskon * 100).toInt()}% untuk sewa >= '
      '$minimalHariDiskon hari',
    );
  }
}
