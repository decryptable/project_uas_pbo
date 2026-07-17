class PenyimpananService {
  Future<void> simpanData(int jumlahData) async {
    print('Menyimpan $jumlahData data ke penyimpanan...');
    await Future<void>.delayed(const Duration(seconds: 2));
    print('Data berhasil disimpan');
  }
}
