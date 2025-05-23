import 'package:flutter/material.dart';
import 'package:mobile_app/config/constants.dart';
import 'package:mobile_app/core/models/asistencia.dart';
import 'package:mobile_app/core/services/api_service.dart';

class MisAsistenciasScreen extends StatefulWidget {
  const MisAsistenciasScreen({super.key});

  @override
  State<MisAsistenciasScreen> createState() => _MisAsistenciasScreenState();
}

class _MisAsistenciasScreenState extends State<MisAsistenciasScreen> {
  List<Asistencia> _asistencias = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarAsistencias();
  }

  Future<void> _cargarAsistencias() async {
    try {
      final data = await ApiService.obtenerMisAsistencias();
      setState(() => _asistencias = data);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar asistencias: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Asistencias'),
        backgroundColor: primaryColor,
      ),
      backgroundColor: backgroundColor,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _asistencias.isEmpty
              ? const Center(child: Text('No hay asistencias registradas.'))
              : ListView.builder(
                  itemCount: _asistencias.length,
                  itemBuilder: (context, index) {
                    final a = _asistencias[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.fecha,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.login,
                                    size: 18, color: Colors.green),
                                const SizedBox(width: 6),
                                Text(
                                    "Entrada: ${a.horaEntrada?.split('.').first ?? '-'}"),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.logout,
                                    size: 18, color: Colors.red),
                                const SizedBox(width: 6),
                                Text(
                                    "Salida: ${a.horaSalida?.split('.').first ?? '-'}"),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (a.observaciones.isNotEmpty)
                              Text("📝 ${a.observaciones}",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic)),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: a.horasTrabajadas != null
                                  ? Text(
                                      "${a.horasTrabajadas!.toStringAsFixed(1)} h",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey))
                                  : const Text("-"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
