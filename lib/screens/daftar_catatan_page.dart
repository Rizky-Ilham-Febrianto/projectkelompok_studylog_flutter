import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/catatan_view_model.dart';
import 'detail_catatan_page.dart';
import 'form_catatan_page.dart';

class DaftarCatatanPage extends StatefulWidget {
  const DaftarCatatanPage({super.key});

  @override
  State<DaftarCatatanPage> createState() => _DaftarCatatanPageState();
}

class _DaftarCatatanPageState extends State<DaftarCatatanPage> {
  final _cari = TextEditingController();

  @override
  void dispose() {
    _cari.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Daftar Catatan')),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: TextField(
              controller: _cari,
              decoration: InputDecoration(
                hintText: 'Cari berdasarkan judul',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: 'Hapus pencarian',
                  onPressed: () {
                    _cari.clear();
                    context.read<CatatanViewModel>().setKataKunci('');
                  },
                ),
              ),
              onChanged: context.read<CatatanViewModel>().setKataKunci,
            ),
          ),
          Expanded(child: _daftar()),
        ]),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const FormCatatanPage())),
          icon: const Icon(Icons.add),
          label: const Text('Tambah'),
        ),
      );

  Widget _daftar() => Consumer<CatatanViewModel>(builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.error != null) {
          return Center(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(vm.error!, textAlign: TextAlign.center),
              TextButton(onPressed: vm.muatCatatan, child: const Text('Coba lagi')),
            ],
          ));
        }
        if (vm.catatan.isEmpty) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('Belum ada catatan. Tekan + untuk menambah catatan.',
                textAlign: TextAlign.center),
          ));
        }
        final tampil = vm.catatanTampil;
        if (tampil.isEmpty) {
          return Center(child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Tidak ada catatan dengan judul "${vm.kataKunci}".',
                textAlign: TextAlign.center),
          ));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: tampil.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final catatan = tampil[index];
            return Card(child: ListTile(
              title: Text(catatan.judul),
              subtitle: Text(catatan.mataKuliah),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => DetailCatatanPage(id: catatan.id!),
              )),
            ));
          },
        );
      });
}
