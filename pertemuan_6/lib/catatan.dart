class Catatan {
  final int? id;
  final String judul;
  final String isi;
  final String kategori;
  final String email;
  final DateTime dibuatPada;

  Catatan({
    this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.email,
    required this.dibuatPada,
  });

  // Untuk REST API (ISO-8601 String)
  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'judul': judul,
        'isi': isi,
        'kategori': kategori,
        'email': email,
        'dibuat_pada': dibuatPada.toUtc().toIso8601String(),
      };

  factory Catatan.fromJson(Map<String, dynamic> m) => Catatan(
        id: m['id'] as int?,
        judul: m['judul'] as String,
        isi: m['isi'] as String,
        kategori: m['kategori'] as String,
        email: m['email'] ?? '',
        dibuatPada: DateTime.parse(m['dibuat_pada'] as String).toLocal(),
      );

  // Fallback map untuk SQLite (jika masih digunakan)
  Map<String, dynamic> toMap() => toJson();
  factory Catatan.fromMap(Map<String, dynamic> map) => Catatan.fromJson(map);

  Catatan copyWith({
    int? id,
    String? judul,
    String? isi,
    String? kategori,
    String? email,
    DateTime? dibuatPada,
  }) {
    return Catatan(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      kategori: kategori ?? this.kategori,
      email: email ?? this.email,
      dibuatPada: dibuatPada ?? this.dibuatPada,
    );
  }
}
