import 'package:flutter/material.dart';
import '../models/tugas.dart';
import 'form_tugas_screen.dart';

class DetailTugasScreen extends StatefulWidget {
  final Tugas tugas;
  final void Function(Tugas tugasBaru) onUbah;
  final void Function(String id) onHapus;

  const DetailTugasScreen({
    super.key,
    required this.tugas,
    required this.onUbah,
    required this.onHapus,
  });

  @override
  State<DetailTugasScreen> createState() => _DetailTugasScreenState();
}

class _DetailTugasScreenState extends State<DetailTugasScreen> {
  late Tugas _tugas;

  @override
  void initState() {
    super.initState();
    _tugas = widget.tugas;
  }

  Future<void> _ubah() async {
    final hasil = await Navigator.push<Tugas>(
      context,
      MaterialPageRoute(builder: (_) => FormTugasScreen(tugas: _tugas)),
    );
    if (hasil == null) return;
    widget.onUbah(hasil); // perbarui List di halaman daftar
    setState(() {
      _tugas = hasil; // tampilkan data terbaru di halaman detail
    });
  }

  Future<void> _konfirmasiHapus() async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Tugas'),
        content: Text('Yakin ingin menghapus "${_tugas.judul}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (yakin != true) return; // Batal: data tidak berubah
    widget.onHapus(_tugas.id);
    if (!mounted) return;
    Navigator.pop(context);
  }

  Widget _baris(String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(nilai)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Tugas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _baris('Judul', _tugas.judul),
            _baris('Mata Kuliah', _tugas.mataKuliah),
            _baris('Deskripsi', _tugas.deskripsi),
            _baris('Tenggat', _tugas.tenggat),
            _baris('Prioritas', _tugas.prioritas),
            _baris('Status', _tugas.selesai ? 'Selesai' : 'Belum selesai'),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _ubah,
                    icon: const Icon(Icons.edit),
                    label: const Text('Ubah'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _konfirmasiHapus,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    icon: const Icon(Icons.delete),
                    label: const Text('Hapus'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}