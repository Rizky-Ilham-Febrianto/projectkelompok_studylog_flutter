import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    _mataKuliah = TextEditingController(text: widget.awal?.mataKuliah ?? '');
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

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.awal == null
            ? 'Tambah Catatan' : 'Ubah Catatan')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          Form(key: _formKey, child: Column(children: [
            _input(_mataKuliah, 'Mata kuliah'),
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
