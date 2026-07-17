import 'package:rental_kendaraan/rental_kendaraan.dart';
import 'package:test/test.dart';

void main() {
  Mobil buatMobil() => Mobil(
    nama: 'Toyota Avanza',
    platNomor: 'K 1234 AB',
    hargaSewaPerHari: 350000,
    jumlahKursi: 7,
  );

  Motor buatMotor() => Motor(
    nama: 'Honda Vario',
    platNomor: 'K 9012 EF',
    hargaSewaPerHari: 100000,
    kapasitasMesin: 160,
  );

  group('Encapsulation dan validasi setter', () {
    test('nama kosong ditolak', () {
      expect(
        () => buatMobil().nama = '   ',
        throwsA(isA<DataTidakValidException>()),
      );
    });

    test('harga negatif ditolak', () {
      expect(
        () => buatMobil().hargaSewaPerHari = -1,
        throwsA(isA<DataTidakValidException>()),
      );
    });

    test('jumlah kursi nol ditolak', () {
      expect(
        () => buatMobil().jumlahKursi = 0,
        throwsA(isA<DataTidakValidException>()),
      );
    });

    test('plat nomor dinormalisasi ke huruf besar', () {
      final Mobil mobil = buatMobil()..platNomor = 'k 1111 zz';
      expect(mobil.platNomor, 'K 1111 ZZ');
    });
  });

  group('Polymorphism hitungBiaya', () {
    test('mobil menambahkan biaya asuransi per hari', () {
      expect(buatMobil().hitungBiaya(2), 350000 * 2 + 50000 * 2);
    });

    test('motor tanpa diskon di bawah 7 hari', () {
      expect(buatMotor().hitungBiaya(3), 300000);
    });

    test('motor mendapat diskon 10% mulai 7 hari', () {
      expect(buatMotor().hitungBiaya(7), 700000 * 0.9);
    });

    test('override berjalan lewat List<Kendaraan>', () {
      final List<Kendaraan> daftar = <Kendaraan>[buatMobil(), buatMotor()];
      final List<double> biaya = daftar
          .map((Kendaraan k) => k.hitungBiaya(1))
          .toList();
      expect(biaya, <double>[400000, 100000]);
    });
  });

  group('Penyewaan', () {
    test('lama sewa nol ditolak', () {
      expect(
        () => Penyewaan(
          kendaraan: buatMotor(),
          namaPenyewa: 'Ichsan',
          lamaHari: 0,
        ),
        throwsA(isA<DataTidakValidException>()),
      );
    });

    test('total biaya mengikuti perhitungan kendaraan', () {
      final Penyewaan penyewaan = Penyewaan(
        kendaraan: buatMobil(),
        namaPenyewa: 'Ichsan',
        lamaHari: 3,
      );
      expect(penyewaan.totalBiaya, buatMobil().hitungBiaya(3));
    });
  });

  group('formatRupiah', () {
    test('memberi pemisah ribuan', () {
      expect(formatRupiah(1250000), 'Rp1.250.000');
    });
  });
}
