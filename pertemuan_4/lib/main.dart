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
  final String email;
  final DateTime dibuatPada;

  Catatan({
    required this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.email,
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
            final arg = settings.arguments;
            // FITUR 1: Reuse halaman untuk Edit — kirim objek Catatan jika edit
            return MaterialPageRoute(
              builder: (_) =>
                  TambahCatatanPage(catatan: arg is Catatan ? arg : null),
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
      email: 'mahasiswa@example.com',
      dibuatPada: DateTime.now(),
    ),
  ];

  // FITUR 2: State untuk Filter Kategori
  String _filterTerpilih = 'Semua';
  final List<String> _kategoriFilter = [
    'Semua',
    'Kuliah',
    'Tugas',
    'Pribadi',
    'Lainnya'
  ];

  // Getter list yang sudah difilter berdasarkan kategori terpilih
  List<Catatan> get _listDifilter {
    if (_filterTerpilih == 'Semua') return _catatan;
    return _catatan.where((c) => c.kategori == _filterTerpilih).toList();
  }

  // ── Tambah catatan baru ──────────────────────────────────────────────────
  Future<void> _bukaTambahCatatan() async {
    final hasil = await Navigator.pushNamed(context, '/tambah');
    if (hasil is Catatan) {
      setState(() => _catatan.add(hasil));
    }
  }

  // ── Edit langsung dari list (tombol pensil di card) ──────────────────────
  Future<void> _editCatatan(Catatan c) async {
    final hasil = await Navigator.pushNamed(context, '/tambah', arguments: c);
    if (hasil is Catatan) {
      setState(() {
        final index = _catatan.indexWhere((item) => item.id == hasil.id);
        if (index != -1) _catatan[index] = hasil;
      });
    }
  }

  // ── Hapus catatan ────────────────────────────────────────────────────────
  void _hapusCatatan(String id) {
    setState(() => _catatan.removeWhere((item) => item.id == id));
  }

  // ── Buka detail; tangani edit yang dilakukan di dalam halaman detail ─────
  //   BUG FIX: setState kosong diganti dengan logic update item yang benar
  Future<void> _bukaDetal(Catatan c) async {
    final hasil =
    await Navigator.pushNamed(context, '/detail', arguments: c);
    if (hasil is Catatan) {
      setState(() {
        final index = _catatan.indexWhere((item) => item.id == hasil.id);
        if (index != -1) _catatan[index] = hasil;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Mahasiswa'),
        backgroundColor: colorScheme.primaryContainer,
        // FITUR 2: Dropdown Filter di AppBar — BUG FIX: tambah dropdownColor &
        //          style agar teks terlihat di atas primaryContainer
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _filterTerpilih,
                icon: Icon(Icons.filter_alt,
                    color: colorScheme.onPrimaryContainer),
                // Warna latar popup menu mengikuti surface theme
                dropdownColor: colorScheme.surface,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                // Teks yang tampil di AppBar (selected value)
                selectedItemBuilder: (context) {
                  return _kategoriFilter.map((k) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        k,
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList();
                },
                items: _kategoriFilter.map((k) {
                  return DropdownMenuItem(value: k, child: Text(k));
                }).toList(),
                onChanged: (baru) {
                  setState(() => _filterTerpilih = baru!);
                },
              ),
            ),
          ),
        ],
      ),
      body: _listDifilter.isEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notes_outlined,
                size: 64, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'Tidak ada catatan\nuntuk kategori "$_filterTerpilih"',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _listDifilter.length,
        itemBuilder: (context, i) {
          final c = _listDifilter[i];
          return Card(
            margin:
            const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
                        materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                        labelStyle: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  // FITUR 3: Tampilkan email di subtitle
                  Text(
                    c.email,
                    style: TextStyle(
                        color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon:
                    const Icon(Icons.edit, color: Colors.blue),
                    tooltip: 'Edit',
                    onPressed: () => _editCatatan(c),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete,
                        color: Colors.red),
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

// === TAMBAH / EDIT PAGE ===
class TambahCatatanPage extends StatefulWidget {
  final Catatan? catatan; // null = mode Tambah, non-null = mode Edit
  const TambahCatatanPage({super.key, this.catatan});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulCtrl;
  late TextEditingController _isiCtrl;
  late TextEditingController _emailCtrl; // FITUR 3: Controller Email
  late String _kategori;

  @override
  void initState() {
    super.initState();
    // Pre-fill form jika mode Edit
    _judulCtrl =
        TextEditingController(text: widget.catatan?.judul ?? '');
    _isiCtrl = TextEditingController(text: widget.catatan?.isi ?? '');
    _emailCtrl =
        TextEditingController(text: widget.catatan?.email ?? '');
    _kategori = widget.catatan?.kategori ?? 'Kuliah';
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.catatan != null;
    return Scaffold(
      appBar: AppBar(
          title: Text(isEdit ? 'Edit Catatan' : 'Tambah Catatan')),
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
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Judul wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            // ── FITUR 3: Email + Validasi Regex ──────────────────────────
            //   BUG FIX: regex lama [\w-]{2,4} tidak support TLD panjang
            //   (.studio, .community, dll). Ganti dengan [\w-]{2,} agar
            //   minimal 2 karakter tanpa batas atas.
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email Pengirim',
                hintText: 'contoh@mail.com',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Email wajib diisi';
                }
                // Regex: local-part @ domain . TLD (min 2 karakter)
                final emailRegex =
                RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$');
                if (!emailRegex.hasMatch(v.trim())) {
                  return 'Format email tidak valid';
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
                  .map((k) =>
                  DropdownMenuItem(value: k, child: Text(k)))
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
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Isi wajib diisi'
                  : null,
            ),
            const SizedBox(height: 24),

            // ── Tombol Simpan ─────────────────────────────────────────────
            FilledButton.icon(
              icon: Icon(isEdit ? Icons.save : Icons.add_task),
              label: Text(
                  isEdit ? 'Simpan Perubahan' : 'Simpan Catatan'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(
                    context,
                    Catatan(
                      // Pertahankan id asli saat edit agar index lookup benar
                      id: widget.catatan?.id ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      judul: _judulCtrl.text.trim(),
                      isi: _isiCtrl.text.trim(),
                      kategori: _kategori,
                      email: _emailCtrl.text.trim(),
                      dibuatPada:
                      widget.catatan?.dibuatPada ?? DateTime.now(),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () async {
              final hasil = await Navigator.pushNamed(
                  context, '/tambah',
                  arguments: catatan);
              // BUG FIX: pop kembali ke Home membawa data terbaru
              // sehingga _bukaDetal() di HomePage dapat update list
              if (hasil is Catatan && context.mounted) {
                Navigator.pop(context, hasil);
              }
            },
          ),
        ],
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

            // Chips: kategori + email
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                Chip(label: Text(catatan.kategori)),
                Chip(
                  avatar: const Icon(Icons.email_outlined, size: 16),
                  label: Text(catatan.email),
                ),
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