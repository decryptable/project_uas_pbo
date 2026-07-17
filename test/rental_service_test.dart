import 'package:rental_kendaraan/rental_kendaraan.dart';
import 'package:test/test.dart';

void main() {
  late RentalService rental;

  setUp(() {
    rental = RentalService()
      ..tambahKendaraan(
        Mobil(
          nama: 'Toyota Avanza',
          platNomor: 'K 1234 AB',
          hargaSewaPerHari: 350000,
          jumlahKursi: 7,
        ),
      )
      ..tambahKendaraan(
        Motor(
          nama: 'Honda Vario',
          platNomor: 'K 9012 EF',
          hargaSewaPerHari: 100000,
          kapasitasMesin: 160,
        ),
      );
  });

  test('plat duplikat ditolak', () {
    expect(
      () => rental.tambahKendaraan(
        Motor(
          nama: 'Motor Lain',
          platNomor: 'k 9012 ef',
          hargaSewaPerHari: 50000,
          kapasitasMesin: 125,
        ),
      ),
      throwsA(isA<DataTidakValidException>()),
    );
  });

  test('sewa menandai kendaraan tidak tersedia', () {
    rental.sewaKendaraan(
      platNomor: 'K 1234 AB',
      namaPenyewa: 'Ichsan',
      lamaHari: 2,
    );
    expect(rental.kendaraanTersedia.length, 1);
    expect(rental.penyewaanAktif.length, 1);
  });

  test('sewa kendaraan yang sedang disewa ditolak', () {
    rental.sewaKendaraan(
      platNomor: 'K 1234 AB',
      namaPenyewa: 'Ichsan',
      lamaHari: 2,
    );
    expect(
      () => rental.sewaKendaraan(
        platNomor: 'K 1234 AB',
        namaPenyewa: 'Budi',
        lamaHari: 1,
      ),
      throwsA(isA<DataTidakValidException>()),
    );
  });

  test('plat tidak terdaftar ditolak', () {
    expect(
      () => rental.sewaKendaraan(
        platNomor: 'B 0000 XX',
        namaPenyewa: 'Ichsan',
        lamaHari: 1,
      ),
      throwsA(isA<DataTidakValidException>()),
    );
  });

  test('pengembalian memulihkan ketersediaan dan mencatat pendapatan', () {
    rental.sewaKendaraan(
      platNomor: 'K 9012 EF',
      namaPenyewa: 'Ichsan',
      lamaHari: 7,
    );
    final Penyewaan selesai = rental.kembalikanKendaraan('k 9012 ef');
    expect(selesai.kendaraan.tersedia, isTrue);
    expect(rental.penyewaanAktif, isEmpty);
    expect(rental.totalPendapatan, 700000 * 0.9);
  });

  test('pengembalian tanpa penyewaan aktif ditolak', () {
    expect(
      () => rental.kembalikanKendaraan('K 1234 AB'),
      throwsA(isA<DataTidakValidException>()),
    );
  });
}
