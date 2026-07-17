String formatRupiah(double nilai) {
  final String angka = nilai.toStringAsFixed(0);
  final RegExp pemisahRibuan = RegExp(r'\B(?=(\d{3})+(?!\d))');
  return 'Rp${angka.replaceAll(pemisahRibuan, '.')}';
}
