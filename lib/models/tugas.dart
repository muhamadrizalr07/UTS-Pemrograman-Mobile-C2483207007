class Tugas {
  final String id;
  final String judul;
  final String mataKuliah;
  final String deskripsi;
  final String tenggat;
  final String prioritas;
  final bool selesai;

  const Tugas ({
    required this.id,
    required this.judul,
    required this.mataKuliah,
    required this.deskripsi,
    required this.tenggat,
    required this.prioritas,
    this.selesai = false,
  });
}