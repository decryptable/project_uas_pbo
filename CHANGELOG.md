# Changelog

## [1.1.0] - 2026-07-17

### Added

- Tampilan berwarna (ANSI) dengan fallback otomatis pada terminal tanpa dukungan.
- Kelas `Konsol` sebagai lapisan tampilan dan pembacaan input.

### Changed

- Menu utama digambar ulang per layar sehingga riwayat terminal tidak menumpuk.
- Setiap aksi tampil pada layar tersendiri dengan jeda sebelum kembali ke menu.

## [1.0.0] - 2026-07-17

### Added

- Class abstrak `Kendaraan` dengan turunan `Mobil` dan `Motor`.
- Encapsulation dengan field privat serta getter/setter tervalidasi.
- Polymorphism pada `tampilkanInfo()` dan `hitungBiaya()` melalui `List<Kendaraan>`.
- `RentalService` dengan `List`, `Map`, dan higher order function (`where`, `any`, `fold`, `map`).
- Custom exception `DataTidakValidException` dengan penanganan `try`-`catch`.
- Simulasi penyimpanan data asinkron pada `PenyimpananService.simpanData()`.
- Menu interaktif CLI dengan delapan fitur utama.
- Pengujian unit untuk model dan service.
- Workflow CI GitHub Actions (format, analyze, test) dan release otomatis dari tag.
- Executable hasil `dart compile exe` untuk Linux, Windows, dan macOS pada setiap release.
