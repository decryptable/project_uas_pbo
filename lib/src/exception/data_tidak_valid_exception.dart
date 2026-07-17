class DataTidakValidException implements Exception {
  const DataTidakValidException(this.pesan);

  final String pesan;

  @override
  String toString() => 'DataTidakValidException: $pesan';
}
