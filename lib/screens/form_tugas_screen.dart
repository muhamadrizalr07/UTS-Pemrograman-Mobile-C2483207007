import 'package:flutter/material.dart';
import '../models/tugas.dart';

class FormTugasScreen extends StatefulWidget {

  final Tugas? tugas;

  const FormTugasScreen({super.key, this.tugas});

  @override
  State<FormTugasScreen> createState() => _FormTugasScreenState();
}

class _FormTugasScreenState extends State<FormTugasScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judulController;
  late final TextEditingController _mataKuliahController;
  late final TextEditingController _deskripsiController;
  late final TextEditingController _tenggatController;
  String? _prioritas;
  late bool _selesai;

  static const List<String> _pilihanPrioritas = ['Rendah', 'Sedang', 'Tinggi'];

  bool get _modeUbah => widget.tugas != null;

  @override
  void initState() {
    super.initState();
    final t = widget.tugas;
    _judulController = TextEditingController(text: t?.judul ?? '');
    _mataKuliahController = TextEditingController(text: t?.mataKuliah ?? '');
    _deskripsiController = TextEditingController(text: t?.deskripsi ?? '');
    _tenggatController = TextEditingController(text: t?.tenggat ?? '');
    _prioritas = t?.prioritas;
    _selesai = t?.selesai ?? false;
  }

  @override
  void dispose() {
    _judulController.dispose();
    _mataKuliahController.dispose();
    _deskripsiController.dispose();
    _tenggatController.dispose();
    super.dispose();
  }

  String? _validasiJudul(String? v) {
    final teks = v?.trim() ?? '';
    if (teks.isEmpty) return 'Judul tidak boleh kosong';
    if (teks.length < 3) return 'Judul minimal 3 karakter';
    return null;
  }

  String? _validasiMataKuliah(String? v) {
    if (v == null || v.trim().isEmpty) return 'Mata kuliah tidak boleh kosong';
    return null;
  }

  String? _validasiDeskripsi(String? v) {
    final teks = v?.trim() ?? '';
    if (teks.isEmpty) return 'Deskripsi tidak boleh kosong';
    if (teks.length < 10) return 'Deskripsi minimal 10 karakter';
    return null;
  }

  String? _validasiTenggat(String? v) {
    final teks = v?.trim() ?? '';
    if (teks.isEmpty) return 'Tenggat tidak boleh kosong';
    if (!RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(teks)) {
      return 'Format harus DD-MM-YYYY';
    }
    final bagian = teks.split('-');
    final hari = int.parse(bagian[0]);
    final bulan = int.parse(bagian[1]);
    final tahun = int.parse(bagian[2]);
    // Cek tanggal nyata: DateTime akan "menggeser" tanggal yang tidak valid
    // (mis. 31-02 menjadi 03-03), sehingga hasilnya dibandingkan kembali.
    final tanggal = DateTime(tahun, bulan, hari);
    if (tanggal.year != tahun || tanggal.month != bulan || tanggal.day != hari) {
      return 'Tanggal tidak valid';
    }
    return null;
  }

  String? _validasiPrioritas(String? v) {
    if (v == null || v.isEmpty) return 'Prioritas wajib dipilih';
    return null;
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final tugas = Tugas(
      id: widget.tugas?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      judul: _judulController.text.trim(),
      mataKuliah: _mataKuliahController.text.trim(),
      deskripsi: _deskripsiController.text.trim(),
      tenggat: _tenggatController.text.trim(),
      prioritas: _prioritas!,
      selesai: _modeUbah ? _selesai : false,
    );
 
    Navigator.pop(context, tugas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_modeUbah ? 'Ubah Tugas' : 'Tambah Tugas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
                validator: _validasiJudul,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mataKuliahController,
                decoration: const InputDecoration(
                  labelText: 'Mata Kuliah',
                  border: OutlineInputBorder(),
                ),
                validator: _validasiMataKuliah,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deskripsiController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: _validasiDeskripsi,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tenggatController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'Tenggat',
                  hintText: 'DD-MM-YYYY',
                  border: OutlineInputBorder(),
                ),
                validator: _validasiTenggat,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                // ignore: deprecated_member_use
                value: _prioritas,
                decoration: const InputDecoration(
                  labelText: 'Prioritas',
                  border: OutlineInputBorder(),
                ),
                items: _pilihanPrioritas
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (nilai) => setState(() => _prioritas = nilai),
                validator: _validasiPrioritas,
              ),
              if (_modeUbah) ...[
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Tugas sudah selesai'),
                  value: _selesai,
                  onChanged: (nilai) => setState(() => _selesai = nilai),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _simpan,
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}