import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'gallery_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // State variables for Profile
  String name = 'Zeina Qurotun Nisa';
  String role = 'Mahasiswa Teknik Informatika';
  String bio = 'Saya suka belajar hal baru, terutama yang berkaitan dengan teknologi dan pengembangan aplikasi mobile.';
  String education = 'Universitas XYZ — Semester 6\nIPK: 3.75';
  String location = 'Bandung, Jawa Barat';
  String contact = 'email@example.com\n+62 812-3456-7890';
  List<String> skills = ['Flutter', 'Dart', 'Firebase', 'Git', 'UI/UX Design'];
  String? profileImagePath;

  // State variables for Experience (Bonus)
  String? expImagePath;
  String expTitle = '';
  String expDescription = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Profil Saya'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.home),
              title: Text('Beranda'),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
            ),
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GalleryHome()),
                );
              },
            ),
            // Bonus 3b: Navigation to Edit Experience
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Upload Pengalaman'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditExperiencePage(
                      initialTitle: expTitle,
                      initialDescription: expDescription,
                      initialImagePath: expImagePath,
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    expTitle = result['title'];
                    expDescription = result['description'];
                    expImagePath = result['imagePath'];
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Pengaturan'),
                    content: const Text('Halaman pengaturan sedang dalam pengembangan.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === HEADER PROFIL ===
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: ClipOval(
                      child: profileImagePath != null
                          ? (kIsWeb
                              ? Image.network(
                                  profileImagePath!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(profileImagePath!),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Image.network(
                                    'https://api.dicebear.com/7.x/avataaars/png?seed=Ilham',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ))
                          : Image.network(
                              'https://api.dicebear.com/7.x/avataaars/png?seed=Ilham',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // === BARIS STATISTIK ===
            const Row(
              children: [
                Expanded(child: _StatBox(label: 'Post', value: '12')),
                Expanded(child: _StatBox(label: 'Teman', value: '128')),
                Expanded(child: _StatBox(label: 'Like', value: '1.2K')),
              ],
            ),
            const SizedBox(height: 24),
            // === SECTION CARDS ===
            _SectionCard(
              icon: Icons.info_outline,
              title: 'Tentang Saya',
              content: bio,
            ),
            _SectionCard(
              icon: Icons.school,
              title: 'Pendidikan',
              content: education,
            ),
            _SectionCard(
              icon: Icons.location_on,
              title: 'Lokasi',
              content: location,
            ),
            _SectionCard(
              icon: Icons.email,
              title: 'Kontak',
              content: contact,
            ),
            // Skills Section
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.star, color: Colors.blue, size: 28),
                        SizedBox(width: 16),
                        Text('Skills', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: skills.map((skill) => Chip(label: Text(skill))).toList(),
                    ),
                  ],
                ),
              ),
            ),
            // Bonus 3a: Experience Section
            if (expTitle.isNotEmpty || expDescription.isNotEmpty || expImagePath != null)
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.work, color: Colors.blue, size: 28),
                          SizedBox(width: 16),
                          Text('Pengalaman', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (expImagePath != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: kIsWeb
                                  ? Image.network(
                                      expImagePath!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(expImagePath!),
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.broken_image, color: Colors.grey),
                                      ),
                                    ),
                            )
                          else
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  expTitle,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  expDescription,
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditProfilePage(
                initialName: name,
                initialBio: bio,
                initialEducation: education,
                initialLocation: location,
                initialContact: contact,
                initialSkills: skills.join(', '),
                initialImagePath: profileImagePath,
              ),
            ),
          );
          if (result != null) {
            setState(() {
              name = result['name'];
              bio = result['bio'];
              education = result['education'];
              location = result['location'];
              contact = result['contact'];
              skills = (result['skills'] as String)
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
              profileImagePath = result['imagePath'];
            });
          }
        },
        label: const Text('Edit Profil'),
        icon: const Icon(Icons.edit),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          NavigationDestination(icon: Icon(Icons.message), label: 'Pesan'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Setting'),
        ],
        onDestinationSelected: (i) {},
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  const _SectionCard({required this.icon, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blue, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(content, style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// === EDIT PROFILE PAGE ===
class EditProfilePage extends StatefulWidget {
  final String initialName;
  final String initialBio;
  final String initialEducation;
  final String initialLocation;
  final String initialContact;
  final String initialSkills;
  final String? initialImagePath;

  const EditProfilePage({
    super.key,
    required this.initialName,
    required this.initialBio,
    required this.initialEducation,
    required this.initialLocation,
    required this.initialContact,
    required this.initialSkills,
    this.initialImagePath,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _eduController;
  late TextEditingController _locController;
  late TextEditingController _contactController;
  late TextEditingController _skillsController;
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _bioController = TextEditingController(text: widget.initialBio);
    _eduController = TextEditingController(text: widget.initialEducation);
    _locController = TextEditingController(text: widget.initialLocation);
    _contactController = TextEditingController(text: widget.initialContact);
    _skillsController = TextEditingController(text: widget.initialSkills);
    _imagePath = widget.initialImagePath;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, {
                'name': _nameController.text,
                'bio': _bioController.text,
                'education': _eduController.text,
                'location': _locController.text,
                'contact': _contactController.text,
                'skills': _skillsController.text,
                'imagePath': _imagePath,
              });
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Foto Profil', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue.shade100,
                  child: ClipOval(
                    child: _imagePath != null
                        ? (kIsWeb
                            ? Image.network(
                                _imagePath!,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(_imagePath!),
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Image.network(
                                  'https://api.dicebear.com/7.x/avataaars/png?seed=Ilham',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ))
                        : Image.network(
                            'https://api.dicebear.com/7.x/avataaars/png?seed=Ilham',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Ganti Foto dari Galeri'),
            ),
            const Divider(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Informasi Profil', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap *',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Bio / Tentang',
                prefixIcon: Icon(Icons.info_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _eduController,
              decoration: const InputDecoration(
                labelText: 'Pendidikan',
                prefixIcon: Icon(Icons.school_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locController,
              decoration: const InputDecoration(
                labelText: 'Lokasi',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contactController,
              decoration: const InputDecoration(
                labelText: 'Kontak',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _skillsController,
              decoration: const InputDecoration(
                labelText: 'Skills (pisahkan dengan koma)',
                prefixIcon: Icon(Icons.star_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context, {
                    'name': _nameController.text,
                    'bio': _bioController.text,
                    'education': _eduController.text,
                    'location': _locController.text,
                    'contact': _contactController.text,
                    'skills': _skillsController.text,
                    'imagePath': _imagePath,
                  });
                },
                icon: const Icon(Icons.save),
                label: const Text('Simpan Perubahan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// === EDIT EXPERIENCE PAGE (BONUS 3c) ===
class EditExperiencePage extends StatefulWidget {
  final String initialTitle;
  final String initialDescription;
  final String? initialImagePath;

  const EditExperiencePage({
    super.key,
    required this.initialTitle,
    required this.initialDescription,
    this.initialImagePath,
  });

  @override
  State<EditExperiencePage> createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descController = TextEditingController(text: widget.initialDescription);
    _imagePath = widget.initialImagePath;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Pengalaman'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, {
                'title': _titleController.text,
                'description': _descController.text,
                'imagePath': _imagePath,
              });
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: kIsWeb
                            ? Image.network(
                                _imagePath!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Image.file(
                                File(_imagePath!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => _buildUploadPlaceholder(),
                              ),
                      )
                    : _buildUploadPlaceholder(),
              ),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Informasi Pengalaman', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul *',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context, {
                    'title': _titleController.text,
                    'description': _descController.text,
                    'imagePath': _imagePath,
                  });
                },
                icon: const Icon(Icons.save),
                label: const Text('Simpan Pengalaman'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate_outlined, size: 48, color: Colors.blue.shade300),
        const SizedBox(height: 8),
        Text('Ketuk untuk pilih gambar', style: TextStyle(color: Colors.blue.shade300)),
        Text('dari galeri perangkat kamu', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
      ],
    );
  }
}
