/// Jadwal kuliah kelas IFB5J (sumber: jadwal perkuliahan semester berjalan).
/// Dipakai StudyLog untuk mengisi kolom "Mata kuliah" secara otomatis
/// berdasarkan hari dan jam saat catatan dibuat.
class JadwalKuliah {
  /// Mengikuti DateTime.weekday: Senin = 1 ... Minggu = 7.
  final int hari;
  final int mulaiMenit; // menit sejak 00:00
  final int selesaiMenit; // menit sejak 00:00
  final String kodeMk;
  final String namaMk;
  final String ruang;

  const JadwalKuliah({
    required this.hari,
    required this.mulaiMenit,
    required this.selesaiMenit,
    required this.kodeMk,
    required this.namaMk,
    required this.ruang,
  });

  static const List<String> _namaHari = [
    'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu',
  ];

  String get namaHari => _namaHari[hari - 1];

  String get jam => '${_format(mulaiMenit)} - ${_format(selesaiMenit)}';

  /// Aktif jika hari sama dan jam berada pada [mulai, selesai).
  /// Pukul 20:30 sudah dihitung masuk ke mata kuliah berikutnya.
  bool aktifPada(DateTime waktu) {
    if (waktu.weekday != hari) return false;
    final menit = waktu.hour * 60 + waktu.minute;
    return menit >= mulaiMenit && menit < selesaiMenit;
  }

  static String _format(int menit) {
    final jam = (menit ~/ 60).toString().padLeft(2, '0');
    final mnt = (menit % 60).toString().padLeft(2, '0');
    return '$jam:$mnt';
  }
}

const List<JadwalKuliah> jadwalIFB5J = [
  // Senin
  JadwalKuliah(
    hari: DateTime.monday, mulaiMenit: 19 * 60, selesaiMenit: 20 * 60 + 30,
    kodeMk: '111500', namaMk: 'Sistem Manajemen Basis Data',
    ruang: 'LAB B (FIKOM)',
  ),
  JadwalKuliah(
    hari: DateTime.monday, mulaiMenit: 20 * 60 + 30, selesaiMenit: 22 * 60,
    kodeMk: '111600', namaMk: 'Teknologi Aplikasi Bergerak',
    ruang: 'LAB A (FIKOM)',
  ),
  // Selasa
  JadwalKuliah(
    hari: DateTime.tuesday, mulaiMenit: 19 * 60, selesaiMenit: 20 * 60 + 30,
    kodeMk: '111100', namaMk: 'Penalaran Komputer', ruang: 'A201',
  ),
  JadwalKuliah(
    hari: DateTime.tuesday, mulaiMenit: 20 * 60 + 30, selesaiMenit: 22 * 60,
    kodeMk: '111400', namaMk: 'Simulasi dan Game Komputer',
    ruang: 'LAB A (FIKOM)',
  ),
  // Rabu
  JadwalKuliah(
    hari: DateTime.wednesday, mulaiMenit: 19 * 60, selesaiMenit: 20 * 60 + 30,
    kodeMk: '111300', namaMk: 'Robotika', ruang: 'LAB ROBOTIK (FIKOM)',
  ),
  JadwalKuliah(
    hari: DateTime.wednesday, mulaiMenit: 20 * 60 + 30, selesaiMenit: 22 * 60,
    kodeMk: '110700', namaMk: 'Kriptografi', ruang: 'A301',
  ),
  // Kamis
  JadwalKuliah(
    hari: DateTime.thursday, mulaiMenit: 19 * 60, selesaiMenit: 20 * 60 + 30,
    kodeMk: '000800', namaMk: 'Penulisan dan Publikasi Ilmiah', ruang: 'A203',
  ),
  // Jumat
  JadwalKuliah(
    hari: DateTime.friday, mulaiMenit: 20 * 60 + 30, selesaiMenit: 22 * 60,
    kodeMk: '111000', namaMk: 'Pemrograman Aplikasi Bergerak',
    ruang: 'LAB A (FIKOM)',
  ),
];

/// Mengembalikan mata kuliah yang sedang berlangsung, atau null jika
/// saat ini tidak ada perkuliahan. Parameter [sekarang] memudahkan pengujian.
JadwalKuliah? cariJadwalAktif([DateTime? sekarang]) {
  final waktu = sekarang ?? DateTime.now();
  for (final jadwal in jadwalIFB5J) {
    if (jadwal.aktifPada(waktu)) return jadwal;
  }
  return null;
}

/// Daftar nama mata kuliah unik, dipakai sebagai pilihan cadangan
/// ketika tidak ada perkuliahan yang sedang aktif.
List<String> get daftarNamaMataKuliah =>
    jadwalIFB5J.map((j) => j.namaMk).toSet().toList();
