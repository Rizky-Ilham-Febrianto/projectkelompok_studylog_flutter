import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/jadwal_kuliah.dart';
import '../models/catatan.dart';
import '../viewmodels/catatan_view_model.dart';

class FormCatatanPage extends StatefulWidget {
  final Catatan? awal;
  const FormCatatanPage({super.key, this.awal});

  @override
  State<FormCatatanPage> createState() => _FormCatatanPageState();
}

class _FormCatatanPageState extends State<FormCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _mataKuliah;
  late final TextEditingController _judul;
  late final TextEditingController _isi;
  bool _menyimpan = false;

  /// Mata kuliah yang sedang berlangsung saat form dibuka (null jika tidak ada).
  JadwalKuliah? _jadwalAktif;

  /// True jika kolom mata kuliah terisi otomatis dan dikunci.
  /// Hanya berlaku untuk catatan baru; saat mengubah catatan, isi lama dipertahankan.
  bool get _otomatis => widget.awal == null && _jadwalAktif != null;

  @override
  void initState() {
    super.initState();
    if (widget.awal == null) {
      _jadwalAktif = cariJadwalAktif();
    }
    _mataKuliah = TextEditingController(
      text: widget.awal?.mataKuliah ?? _jadwalAktif?.namaMk ?? '',
    );
    _judul = TextEditingController(text: widget.awal?.judul ?? '');
    _isi = TextEditingController(text: widget.awal?.isi ?? '');
  }

  @override
  void dispose() {
    _mataKuliah.dispose();
    _judul.dispose();
    _isi.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate() || _menyimpan) return;
    setState(() => _menyimpan = true);
    final data = Catatan(
      id: widget.awal?.id,
      mataKuliah: _mataKuliah.text.trim(),
      judul: _judul.text.trim(),
      isi: _isi.text.trim(),
      tanggal: widget.awal?.tanggal ?? DateTime.now(),
    );
    try {
      final vm = context.read<CatatanViewModel>();
      if (widget.awal == null) {
        await vm.tambahCatatan(data);
      } else {
        await vm.ubahCatatan(data);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')));
    } finally {
      if (mounted) setState(() => _menyimpan = false);
    }
  }

  Widget _input(TextEditingController kontrol, String label, {int baris = 1}) {
    return TextFormField(
      controller: kontrol,
      maxLines: baris,
      decoration: InputDecoration(labelText: label),
      validator: (teks) => (teks == null || teks.trim().isEmpty)
          ? '$label wajib diisi' : null,
    );
  }

  /// Kolom mata kuliah:
  /// - Ada kuliah aktif  -> terisi otomatis sesuai jadwal dan tidak perlu diketik.
  /// - Tidak ada kuliah  -> bisa diketik atau dipilih dari daftar mata kuliah.
  Widget _inputMataKuliah() {
    final jadwal = _jadwalAktif;
    return TextFormField(
      controller: _mataKuliah,
      readOnly: _otomatis,
      decoration: InputDecoration(
        labelText: 'Mata kuliah',
        helperText: _otomatis
            ? 'Terisi otomatis: ${jadwal!.namaHari} ${jadwal.jam} - ${jadwal.ruang}'
            : 'Tidak ada kuliah yang sedang berlangsung. Pilih dari daftar atau ketik.',
        helperMaxLines: 2,
        suffixIcon: _otomatis
            ? const Icon(Icons.schedule)
            : PopupMenuButton<String>(
                icon: const Icon(Icons.arrow_drop_down),
                tooltip: 'Pilih mata kuliah',
                onSelected: (nama) => _mataKuliah.text = nama,
                itemBuilder: (_) => [
                  for (final nama in daftarNamaMataKuliah)
                    PopupMenuItem(value: nama, child: Text(nama)),
                ],
              ),
      ),
      validator: (teks) => (teks == null || teks.trim().isEmpty)
          ? 'Mata kuliah wajib diisi' : null,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.awal == null
            ? 'Tambah Catatan' : 'Ubah Catatan')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          Form(key: _formKey, child: Column(children: [
            _inputMataKuliah(),
            const SizedBox(height: 14),
            _input(_judul, 'Judul'),
            const SizedBox(height: 14),
            _input(_isi, 'Isi catatan', baris: 5),
          ])),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: _menyimpan ? null : _simpan,
            icon: const Icon(Icons.save),
            label: Text(_menyimpan ? 'Menyimpan...' : 'Simpan'),
          ),
        ]),
      );
}
