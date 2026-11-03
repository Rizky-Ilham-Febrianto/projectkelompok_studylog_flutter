import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/catatan.dart';
import '../viewmodels/catatan_view_model.dart';
import 'form_catatan_page.dart';

class DetailCatatanPage extends StatelessWidget {
  final int id;
  const DetailCatatanPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Detail Catatan')),
        body: Consumer<CatatanViewModel>(builder: (context, vm, _) {
          Catatan? catatan;
          for (final item in vm.catatan) {
            if (item.id == id) {
              catatan = item;
              break;
            }
          }
          if (catatan == null) {
            return const Center(child: Text('Catatan tidak ditemukan.'));
          }
          final data = catatan;
          return ListView(padding: const EdgeInsets.all(20), children: [
            Text(data.mataKuliah, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(data.judul, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Dibuat: ${data.tanggal.day}/${data.tanggal.month}/${data.tanggal.year}'),
            const Divider(height: 32),
            Text(data.isi),
            const SizedBox(height: 28),
            FilledButton.tonalIcon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => FormCatatanPage(awal: data))),
              icon: const Icon(Icons.edit), label: const Text('Ubah'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => _konfirmasiHapus(context, vm, data.id!),
              icon: const Icon(Icons.delete_outline), label: const Text('Hapus'),
            ),
          ]);
        }),
      );

  Future<void> _konfirmasiHapus(
      BuildContext context, CatatanViewModel vm, int id) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus catatan?'),
        content: const Text('Catatan yang dihapus tidak dapat dikembalikan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Hapus')),
        ],
      ),
    );
    if (yakin != true || !context.mounted) return;
    try {
      await vm.hapusCatatan(id);
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: $e')));
    }
  }
}
