import 'dart:io';

import '../exception/data_tidak_valid_exception.dart';

class Konsol {
  Konsol() : _ansiAktif = stdout.supportsAnsiEscapes;

  final bool _ansiAktif;

  String tebal(String teks) => _bungkus(teks, '1');

  String redup(String teks) => _bungkus(teks, '90');

  String merah(String teks) => _bungkus(teks, '31');

  String hijau(String teks) => _bungkus(teks, '32');

  String kuning(String teks) => _bungkus(teks, '33');

  String biru(String teks) => _bungkus(teks, '36');

  String _bungkus(String teks, String kode) =>
      _ansiAktif ? '\x1B[${kode}m$teks\x1B[0m' : teks;

  void bersihkanLayar() {
    if (_ansiAktif) {
      stdout.write('\x1B[2J\x1B[H');
    } else {
      print('');
    }
  }

  void jeda() {
    stdout.write(redup('Tekan Enter untuk kembali...'));
    stdin.readLineSync();
  }

  String bacaTeks(String label) {
    stdout.write(biru(label));
    return stdin.readLineSync()?.trim() ?? '';
  }

  int bacaAngka(String label) {
    final String masukan = bacaTeks(label);
    final int? nilai = int.tryParse(masukan);
    if (nilai == null) {
      throw DataTidakValidException('"$masukan" bukan bilangan bulat.');
    }
    return nilai;
  }

  double bacaDesimal(String label) {
    final String masukan = bacaTeks(label);
    final double? nilai = double.tryParse(masukan);
    if (nilai == null) {
      throw DataTidakValidException('"$masukan" bukan angka.');
    }
    return nilai;
  }
}
