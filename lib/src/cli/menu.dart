import '../exception/data_tidak_valid_exception.dart';
import '../model/kendaraan.dart';
import '../model/mobil.dart';
import '../model/motor.dart';
import '../model/penyewaan.dart';
import '../service/penyimpanan_service.dart';
import '../service/rental_service.dart';
import '../util/format_rupiah.dart';
import 'konsol.dart';

class Menu {
  Menu(this._rental, this._penyimpanan, this._konsol);

  final RentalService _rental;
  final PenyimpananService _penyimpanan;
  final Konsol _konsol;
  String _status = '';

  Future<void> jalankan() async {
    bool berjalan = true;
    while (berjalan) {
      _tampilkanMenuUtama();
      try {
        berjalan = await _prosesPilihan(_konsol.bacaTeks('Pilih menu: '));
      } on DataTidakValidException catch (e) {
        _status = _konsol.merah('[GAGAL] ${e.pesan}');
      }
    }
    print(_konsol.hijau('Terima kasih telah menggunakan aplikasi.'));
  }

  void _tampilkanMenuUtama() {
    _konsol.bersihkanLayar();
    print(_konsol.tebal('=== SISTEM PENYEWAAN KENDARAAN ==='));
    print(
      _konsol.redup(
        '${_rental.semuaKendaraan.length} kendaraan | '
        '${_rental.penyewaanAktif.length} penyewaan aktif | '
        'Pendapatan ${formatRupiah(_rental.totalPendapatan)}',
      ),
    );
    if (_status.isNotEmpty) {
      print(_status);
      _status = '';
    }
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
    print('');
  }

  Future<bool> _prosesPilihan(String pilihan) async {
    switch (pilihan) {
      case '1':
        _layarDaftarKendaraan('Semua Kendaraan', _rental.semuaKendaraan);
      case '2':
        _layarDaftarKendaraan('Kendaraan Tersedia', _rental.kendaraanTersedia);
      case '3':
        _tambahKendaraan();
      case '4':
        _sewaKendaraan();
      case '5':
        _kembalikanKendaraan();
      case '6':
        _layarPenyewaanAktif();
      case '7':
        _layarLaporan();
      case '8':
        await _simpanData();
      case '0':
        return false;
      default:
        _status = _konsol.merah('Pilihan "$pilihan" tidak dikenal.');
    }
    return true;
  }

  void _bukaLayar(String judul) {
    _konsol.bersihkanLayar();
    print(_konsol.tebal(_konsol.kuning('== $judul ==')));
    print('');
  }

  void _layarDaftarKendaraan(String judul, List<Kendaraan> daftar) {
    _bukaLayar(judul);
    if (daftar.isEmpty) {
      print('Tidak ada kendaraan.');
    }
    for (final Kendaraan kendaraan in daftar) {
      kendaraan.tampilkanInfo();
    }
    print('');
    _konsol.jeda();
  }

  void _tambahKendaraan() {
    _bukaLayar('Tambah Kendaraan');
    print('Jenis kendaraan: 1) Mobil  2) Motor');
    final String jenis = _konsol.bacaTeks('Pilih jenis: ');
    final String nama = _konsol.bacaTeks('Nama kendaraan: ');
    final String plat = _konsol.bacaTeks('Plat nomor: ');
    final double harga = _konsol.bacaDesimal('Harga sewa per hari: ');
    final Kendaraan kendaraan = switch (jenis) {
      '1' => Mobil(
        nama: nama,
        platNomor: plat,
        hargaSewaPerHari: harga,
        jumlahKursi: _konsol.bacaAngka('Jumlah kursi: '),
      ),
      '2' => Motor(
        nama: nama,
        platNomor: plat,
        hargaSewaPerHari: harga,
        kapasitasMesin: _konsol.bacaAngka('Kapasitas mesin (cc): '),
      ),
      _ => throw const DataTidakValidException(
        'Jenis kendaraan harus 1 atau 2.',
      ),
    };
    _rental.tambahKendaraan(kendaraan);
    _status = _konsol.hijau(
      '${kendaraan.jenis} "${kendaraan.nama}" berhasil ditambahkan.',
    );
  }

  void _sewaKendaraan() {
    _bukaLayar('Sewa Kendaraan');
    for (final Kendaraan kendaraan in _rental.kendaraanTersedia) {
      kendaraan.tampilkanInfo();
    }
    print('');
    final Penyewaan penyewaan = _rental.sewaKendaraan(
      platNomor: _konsol.bacaTeks('Plat nomor: '),
      namaPenyewa: _konsol.bacaTeks('Nama penyewa: '),
      lamaHari: _konsol.bacaAngka('Lama sewa (hari): '),
    );
    _status = _konsol.hijau(
      'Penyewaan dicatat: ${penyewaan.namaPenyewa} - '
      '${penyewaan.kendaraan.nama}, ${penyewaan.lamaHari} hari, '
      'total ${formatRupiah(penyewaan.totalBiaya)}.',
    );
  }

  void _kembalikanKendaraan() {
    _bukaLayar('Kembalikan Kendaraan');
    final Penyewaan penyewaan = _rental.kembalikanKendaraan(
      _konsol.bacaTeks('Plat nomor yang dikembalikan: '),
    );
    _status = _konsol.hijau(
      '${penyewaan.kendaraan.nama} dikembalikan. '
      'Tagihan: ${formatRupiah(penyewaan.totalBiaya)}.',
    );
  }

  void _layarPenyewaanAktif() {
    _bukaLayar('Penyewaan Aktif');
    if (_rental.penyewaanAktif.isEmpty) {
      print('Tidak ada penyewaan aktif.');
    }
    for (final Penyewaan penyewaan in _rental.penyewaanAktif) {
      penyewaan.tampilkanInfo();
    }
    print('');
    _konsol.jeda();
  }

  void _layarLaporan() {
    _bukaLayar('Laporan');
    final List<String> namaTersedia = _rental.kendaraanTersedia
        .map((Kendaraan k) => k.nama)
        .toList();
    print('Kendaraan tersedia : ${namaTersedia.join(', ')}');
    print('Penyewaan aktif    : ${_rental.penyewaanAktif.length}');
    print(
      'Total pendapatan   : '
      '${_konsol.hijau(formatRupiah(_rental.totalPendapatan))}',
    );
    print('');
    _konsol.jeda();
  }

  Future<void> _simpanData() async {
    _bukaLayar('Simpan Data');
    await _penyimpanan.simpanData(_rental.jumlahData);
    print('');
    _konsol.jeda();
  }
}
