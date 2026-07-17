import 'package:rental_kendaraan/rental_kendaraan.dart';

Future<void> main() async {
  final RentalService rental = RentalService()
    ..tambahKendaraan(
      Mobil(
        nama: 'Toyota Avanza',
        platNomor: 'K 1234 AB',
        hargaSewaPerHari: 350000,
        jumlahKursi: 7,
      ),
    )
    ..tambahKendaraan(
      Mobil(
        nama: 'Honda Brio',
        platNomor: 'K 5678 CD',
        hargaSewaPerHari: 300000,
        jumlahKursi: 5,
      ),
    )
    ..tambahKendaraan(
      Motor(
        nama: 'Honda Vario 160',
        platNomor: 'K 9012 EF',
        hargaSewaPerHari: 75000,
        kapasitasMesin: 160,
      ),
    )
    ..tambahKendaraan(
      Motor(
        nama: 'Yamaha NMAX',
        platNomor: 'K 3456 GH',
        hargaSewaPerHari: 100000,
        kapasitasMesin: 155,
      ),
    );

  final Menu menu = Menu(rental, PenyimpananService(), Konsol());
  await menu.jalankan();
}
