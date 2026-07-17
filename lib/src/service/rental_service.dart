import '../exception/data_tidak_valid_exception.dart';
import '../model/kendaraan.dart';
import '../model/penyewaan.dart';

class RentalService {
  final List<Kendaraan> _daftarKendaraan = <Kendaraan>[];
  final Map<String, Penyewaan> _penyewaanAktif = <String, Penyewaan>{};
  final List<Penyewaan> _riwayatSelesai = <Penyewaan>[];

  List<Kendaraan> get semuaKendaraan =>
      List<Kendaraan>.unmodifiable(_daftarKendaraan);

  List<Kendaraan> get kendaraanTersedia =>
      _daftarKendaraan.where((Kendaraan k) => k.tersedia).toList();

  List<Penyewaan> get penyewaanAktif =>
      List<Penyewaan>.unmodifiable(_penyewaanAktif.values);

  int get jumlahData =>
      _daftarKendaraan.length + _penyewaanAktif.length + _riwayatSelesai.length;

  double get totalPendapatan => _riwayatSelesai.fold<double>(
    0,
    (double total, Penyewaan p) => total + p.totalBiaya,
  );

  void tambahKendaraan(Kendaraan kendaraan) {
    final bool platSudahAda = _daftarKendaraan.any(
      (Kendaraan k) => k.platNomor == kendaraan.platNomor,
    );
    if (platSudahAda) {
      throw DataTidakValidException(
        'Plat ${kendaraan.platNomor} sudah terdaftar.',
      );
    }
    _daftarKendaraan.add(kendaraan);
  }

  Penyewaan sewaKendaraan({
    required String platNomor,
    required String namaPenyewa,
    required int lamaHari,
  }) {
    final Kendaraan kendaraan = _cariKendaraan(platNomor);
    if (!kendaraan.tersedia) {
      throw DataTidakValidException(
        '${kendaraan.nama} (${kendaraan.platNomor}) sedang disewa.',
      );
    }
    final Penyewaan penyewaan = Penyewaan(
      kendaraan: kendaraan,
      namaPenyewa: namaPenyewa,
      lamaHari: lamaHari,
    );
    kendaraan.tandaiDisewa();
    _penyewaanAktif[kendaraan.platNomor] = penyewaan;
    return penyewaan;
  }

  Penyewaan kembalikanKendaraan(String platNomor) {
    final String kunci = platNomor.trim().toUpperCase();
    final Penyewaan? penyewaan = _penyewaanAktif.remove(kunci);
    if (penyewaan == null) {
      throw DataTidakValidException(
        'Tidak ada penyewaan aktif untuk plat $kunci.',
      );
    }
    penyewaan.kendaraan.tandaiTersedia();
    _riwayatSelesai.add(penyewaan);
    return penyewaan;
  }

  Kendaraan _cariKendaraan(String platNomor) {
    final String kunci = platNomor.trim().toUpperCase();
    return _daftarKendaraan.firstWhere(
      (Kendaraan k) => k.platNomor == kunci,
      orElse: () => throw DataTidakValidException(
        'Kendaraan dengan plat $kunci tidak ditemukan.',
      ),
    );
  }
}
