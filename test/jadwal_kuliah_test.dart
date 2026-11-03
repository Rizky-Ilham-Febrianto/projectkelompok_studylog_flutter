import 'package:flutter_test/flutter_test.dart';
import 'package:studylog_flutter/data/jadwal_kuliah.dart';

void main() {
  // 2 November 2026 = Senin, 3 = Selasa, 4 = Rabu, 5 = Kamis, 6 = Jumat, 7 = Sabtu
  test('Senin 19:30 -> Sistem Manajemen Basis Data', () {
    final j = cariJadwalAktif(DateTime(2026, 11, 2, 19, 30));
    expect(j?.namaMk, 'Sistem Manajemen Basis Data');
  });

  test('Senin 20:30 tepat -> sudah pindah ke Teknologi Aplikasi Bergerak', () {
    final j = cariJadwalAktif(DateTime(2026, 11, 2, 20, 30));
    expect(j?.namaMk, 'Teknologi Aplikasi Bergerak');
  });

  test('Jumat 21:00 -> Pemrograman Aplikasi Bergerak', () {
    final j = cariJadwalAktif(DateTime(2026, 11, 6, 21, 0));
    expect(j?.namaMk, 'Pemrograman Aplikasi Bergerak');
  });

  test('Kamis 19:15 -> Penulisan dan Publikasi Ilmiah', () {
    final j = cariJadwalAktif(DateTime(2026, 11, 5, 19, 15));
    expect(j?.namaMk, 'Penulisan dan Publikasi Ilmiah');
  });

  test('Jam 22:00 dan sebelum 19:00 -> tidak ada kuliah', () {
    expect(cariJadwalAktif(DateTime(2026, 11, 2, 22, 0)), isNull);
    expect(cariJadwalAktif(DateTime(2026, 11, 2, 18, 59)), isNull);
  });

  test('Jumat 19:30 (belum ada jadwal) dan Sabtu -> tidak ada kuliah', () {
    expect(cariJadwalAktif(DateTime(2026, 11, 6, 19, 30)), isNull);
    expect(cariJadwalAktif(DateTime(2026, 11, 7, 19, 30)), isNull);
  });

  test('Daftar nama mata kuliah unik berjumlah 8', () {
    expect(daftarNamaMataKuliah.length, 8);
  });
}
