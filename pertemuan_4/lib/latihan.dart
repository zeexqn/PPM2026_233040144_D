import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // FIX: untuk initializeDateFormatting

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null); // FIX: init locale 'id' sebelum runApp
  runApp(const MyApp());
}

// === MODEL ===
class Catatan {
  final String id;
  final String judul;
  final String isi;
  final String kategori;
  final DateTime dibuatPada;

  Catatan({
    required this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.dibuatPada,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa (Tugas)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/tambah':
            return MaterialPageRoute(
              builder: (_) => const TambahCatatanPage(),
            );
          case '/detail':
            final catatan = settings.arguments as Catatan;
            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(catatan: catatan),
            );
          default:
            return null;
        }
      },
    );
  }
}

// === HOME PAGE ===
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Catatan> _catatan = [
    Catatan(
      id: '1',
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation.',
      kategori: 'Kuliah',
      dibuatPada: DateTime.now(),
    ),
  ];

  // ── Tambah catatan baru ──────────────────────────────────────────────────
  Future<void> _bukaTambahCatatan() async {
    final hasil = await Navigator.pushNamed(context, '/tambah');
    if (hasil is Catatan) {
      setState(() => _catatan.add(hasil));
    }
  }

  // ── Hapus catatan ────────────────────────────────────────────────────────
  void _hapusCatatan(String id) {
    setState(() => _catatan.removeWhere((item) => item.id == id));
  }

  // ── Buka detail ──────────────────────────────────────────────────────────
  void _bukaDetal(Catatan c) {
    Navigator.pushNamed(context, '/detail', arguments: c);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Mahasiswa'),
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: _catatan.isEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notes_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'Tidak ada catatan',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _catatan.length,
        itemBuilder: (context, i) {
          final c = _catatan[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
              title: Text(
                c.judul,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        label: Text(c.kategori),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        labelStyle: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Hapus',
                    onPressed: () => _hapusCatatan(c.id),
                  ),
                ],
              ),
              onTap: () => _bukaDetal(c),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaTambahCatatan,
        tooltip: 'Tambah Catatan',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// === TAMBAH PAGE ===
class TambahCatatanPage extends StatefulWidget {
  const TambahCatatanPage({super.key});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulCtrl;
  late TextEditingController _isiCtrl;
  late String _kategori;

  @override
  void initState() {
    super.initState();
    _judulCtrl = TextEditingController(text: '');
    _isiCtrl = TextEditingController(text: '');
    _kategori = 'Kuliah';
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Catatan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Judul ────────────────────────────────────────────────────
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Judul wajib diisi';
                }
                // FITUR: Muncul pesan error jika kurang dari 3 karakter
                if (v.trim().length < 3) {
                  return 'Minimal 3 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ── Kategori ─────────────────────────────────────────────────
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya']
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _kategori = v!),
            ),
            const SizedBox(height: 16),

            // ── Isi Catatan ───────────────────────────────────────────────
            TextFormField(
              controller: _isiCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi Catatan',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Isi wajib diisi' : null,
            ),
            const SizedBox(height: 24),

            // ── Tombol Simpan ─────────────────────────────────────────────
            FilledButton.icon(
              icon: const Icon(Icons.add_task),
              label: const Text('Simpan Catatan'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(
                    context,
                    Catatan(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      judul: _judulCtrl.text.trim(),
                      isi: _isiCtrl.text.trim(),
                      kategori: _kategori,
                      dibuatPada: DateTime.now(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// === DETAIL PAGE ===
class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;
  const DetailCatatanPage({super.key, required this.catatan});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy, HH:mm', 'id');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul
            Text(
              catatan.judul,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Chips: kategori
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                Chip(label: Text(catatan.kategori)),
              ],
            ),

            // Tanggal dibuat
            const SizedBox(height: 4),
            Text(
              'Dibuat: ${fmt.format(catatan.dibuatPada)}',
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),

            const Divider(height: 40),

            // Isi catatan
            Text(
              catatan.isi,
              style: const TextStyle(fontSize: 17, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}