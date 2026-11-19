import 'package:flutter/material.dart';
import '../models/tugas.dart';
import 'detail_tugas_screen.dart';
import 'form_tugas_screen.dart';

class DaftarTugasScreen extends StatefulWidget {
  const DaftarTugasScreen({super.key});

  @override
  State<DaftarTugasScreen> createState() => _DaftarTugasScreenState();
}

class _DaftarTugasScreenState extends State<DaftarTugasScreen> {
  final List<Tugas> _daftarTugas = [
    const Tugas(
      id: '1',
      judul: 'Laporan Praktikum Basis Data',
      mataKuliah: 'Basis Data',
      deskripsi: 'Membuat laporan ERD dan query SQL untuk studi kasus toko.',
      tenggat: '25-11-2026',
      prioritas: 'Tinggi',
    ),
    const Tugas(
      id: '2',
      judul: 'Makalah Etika Profesi',
      mataKuliah: 'Etika Profesi TI',
      deskripsi: 'Menulis makalah 5 halaman tentang etika penggunaan data.',
      tenggat: '30-11-2026',
      prioritas: 'Sedang',
    ),
    const Tugas(
      id: '3',
      judul: 'Rangkuman Jaringan Komputer',
      mataKuliah: 'Jaringan Komputer',
      deskripsi: 'Merangkum materi model OSI dan TCP/IP dari pertemuan 1-6.',
      tenggat: '05-12-2026',
      prioritas: 'Rendah',
      selesai: true,
    ),
  ];

  Color _warnaPrioritas(String prioritas) {
    switch (prioritas) {
      case 'Tinggi':
        return Colors.red;
      case 'Sedang':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  void _tampilkanSnackBar(String pesan) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(pesan)));
  }

  Future<void> _tambahTugas() async {
    final hasil = await Navigator.push<Tugas>(
      context,
      MaterialPageRoute(builder: (_) => const FormTugasScreen()),
    );
    if (hasil == null) return;
    setState(() {
      _daftarTugas.add(hasil);
    });
    _tampilkanSnackBar('Tugas berhasil ditambahkan');
  }

  void _ubahTugas(Tugas tugasBaru) {
    final index = _daftarTugas.indexWhere((t) => t.id == tugasBaru.id);
    if (index == -1) return;
    setState(() {
      _daftarTugas[index] = tugasBaru;
    });
    _tampilkanSnackBar('Tugas berhasil diperbarui');
  }

  void _hapusTugas(String id) {
    final index = _daftarTugas.indexWhere((t) => t.id == id);
    if (index == -1) return;
    setState(() {
      _daftarTugas.removeAt(index);
    });
    _tampilkanSnackBar('Tugas berhasil dihapus');
  }

  void _bukaDetail(Tugas tugas) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailTugasScreen(
          tugas: tugas,
          onUbah: _ubahTugas,
          onHapus: _hapusTugas,
        ),
      ),
    );
  }

  Widget _ringkasanItem(String label, int jumlah) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$jumlah',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _daftarTugas.length;
    final selesai = _daftarTugas.where((t) => t.selesai).length;
    final belum = total - selesai;

    return Scaffold(
      appBar: AppBar(title: const Text('TugasKu')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.blue.shade50,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                _ringkasanItem('Total', total),
                _ringkasanItem('Selesai', selesai),
                _ringkasanItem('Belum Selesai', belum),
              ],
            ),
          ),
          Expanded(
            child: _daftarTugas.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.assignment_outlined,
                              size: 72, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            'Belum ada tugas.\nTekan tombol + untuk menambah tugas.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _daftarTugas.length,
                    itemBuilder: (context, index) {
                      final tugas = _daftarTugas[index];
                      return ListTile(
                        leading: Icon(
                          tugas.selesai
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: tugas.selesai ? Colors.green : Colors.grey,
                        ),
                        title: Text(
                          tugas.judul,
                          style: TextStyle(
                            decoration: tugas.selesai
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tugas.mataKuliah),
                            Text('Tenggat: ${tugas.tenggat}'),
                            Text(
                              'Prioritas: ${tugas.prioritas}  |  '
                              '${tugas.selesai ? 'Selesai' : 'Belum selesai'}',
                              style: TextStyle(
                                color: _warnaPrioritas(tugas.prioritas),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _bukaDetail(tugas),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahTugas,
        tooltip: 'Tambah tugas',
        child: const Icon(Icons.add),
      ),
    );
  }
}