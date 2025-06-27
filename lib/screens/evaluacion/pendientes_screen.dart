import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/evaluacion_pendiente.dart';
import 'package:mobile_app/core/services/api_service.dart';
import 'package:intl/intl.dart';

class PendientesEvaluacionScreen extends StatefulWidget {
  const PendientesEvaluacionScreen({super.key});

  @override
  State<PendientesEvaluacionScreen> createState() =>
      _PendientesEvaluacionScreenState();
}

class _PendientesEvaluacionScreenState
    extends State<PendientesEvaluacionScreen> {
  late Future<List<EvaluacionPendiente>> _pendientesFuture;

  @override
  void initState() {
    super.initState();
    _pendientesFuture = ApiService.obtenerEvaluacionesPendientesEvaluar();
  }

  Future<void> _aceptarEvaluacion(
      BuildContext context, EvaluacionPendiente item) async {
    try {
      await ApiService.aceptarEvaluacion(id: item.id);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evaluación aceptada correctamente')),
      );
      setState(() {
        _pendientesFuture = ApiService.obtenerEvaluacionesPendientesEvaluar();
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al aceptar evaluación: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Evaluaciones Pendientes')),
      body: FutureBuilder<List<EvaluacionPendiente>>(
        future: _pendientesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final pendientes = snapshot.data ?? [];
          if (pendientes.isEmpty) {
            return const Center(child: Text('No hay evaluaciones pendientes.'));
          }
          return ListView.separated(
            itemCount: pendientes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = pendientes[index];
              final fechaSolicitud = item.fechaCreacion != null
                  ? DateFormat('yyyy-MM-dd').format(item.fechaCreacion!)
                  : '';
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Motivo: ${item.motivo}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('Fecha de solicitud: $fechaSolicitud'),
                      Text('Estado: ${item.estado}'),
                      Text('Evaluado: ${item.evaluadoNombre}'),
                      Text('Solicitador: ${item.solicitadorNombre}'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.assignment_turned_in,
                                color: Colors.blue, size: 26),
                            label: const Text('Aceptar evaluación',
                                style: TextStyle(color: Colors.blue)),
                            onPressed: () {
                              _aceptarEvaluacion(context, item);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
