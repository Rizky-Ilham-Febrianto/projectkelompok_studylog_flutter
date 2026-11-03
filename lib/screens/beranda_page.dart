import 'package:flutter/material.dart';
import 'daftar_catatan_page.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('StudyLog')),
        body: Center(child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.menu_book_rounded, size: 84,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 24),
            Text('Kelola catatan kuliahmu',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            const Text('Simpan catatan di perangkat. Tetap dapat dibuka tanpa internet.',
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DaftarCatatanPage())),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Lihat Catatan'),
            ),
          ]),
        )),
      );
}
