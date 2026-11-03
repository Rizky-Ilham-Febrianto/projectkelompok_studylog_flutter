import 'package:flutter/material.dart';

void main() => runApp(const StudyLogApp());

class StudyLogApp extends StatelessWidget {
  const StudyLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyLog | Praktikum 1',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const CatatanFormSederhana(),
    );
  }
}

class CatatanFormSederhana extends StatefulWidget {
  const CatatanFormSederhana({super.key});

  @override
  State<CatatanFormSederhana> createState() => _CatatanFormSederhanaState();
}

class _CatatanFormSederhanaState extends State<CatatanFormSederhana> {
  final _formKey = GlobalKey<FormState>();
  final _mataKuliah = TextEditingController();
  final _judul = TextEditingController();
  final _isi = TextEditingController();
  String? _hasil;

  @override
  void dispose() {
    _mataKuliah.dispose();
    _judul.dispose();
    _isi.dispose();
    super.dispose();
  }

  void _simpanSementara() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _hasil = '${_mataKuliah.text.trim()} | ${_judul.text.trim()}';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data ditampilkan (belum tersimpan permanen).')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StudyLog - Form Catatan')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Praktikum 1: State & Interaksi',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _mataKuliah,
                  decoration: const InputDecoration(labelText: 'Mata kuliah', border: OutlineInputBorder()),
                  validator: (nilai) => (nilai == null || nilai.trim().isEmpty)
                      ? 'Mata kuliah wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _judul,
                  decoration: const InputDecoration(labelText: 'Judul catatan', border: OutlineInputBorder()),
                  validator: (nilai) => (nilai == null || nilai.trim().isEmpty)
                      ? 'Judul wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _isi,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Isi catatan', border: OutlineInputBorder()),
                  validator: (nilai) => (nilai == null || nilai.trim().isEmpty)
                      ? 'Isi catatan wajib diisi' : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(onPressed: _simpanSementara, icon: const Icon(Icons.save),
              label: const Text('Tampilkan Catatan')),
          if (_hasil != null) ...[
            const SizedBox(height: 18),
            Card(child: Padding(padding: const EdgeInsets.all(16),
              child: Text('Hasil input: $_hasil'))),
          ],
        ],
      ),
    );
  }
}
