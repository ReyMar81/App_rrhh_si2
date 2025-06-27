import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/api_service.dart';

class PendientesHorasExtrasScreen extends StatefulWidget {
  const PendientesHorasExtrasScreen({super.key});

  @override
  State<PendientesHorasExtrasScreen> createState() =>
      _PendientesHorasExtrasScreenState();
}

class _PendientesHorasExtrasScreenState
    extends State<PendientesHorasExtrasScreen> {
  late Future<List<dynamic>> _pendientesFuture;

  @override
  void initState() {
    super.initState();
    _pendientesFuture = _fetchPendientes();
  }

  Future<List<dynamic>> _fetchPendientes() async {
    // Debes implementar este método en ApiService
    return await ApiService.obtenerHorasExtrasPendientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pendientes por Aprobar')),
      body: FutureBuilder<List<dynamic>>(
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
            return const Center(child: Text('No hay solicitudes pendientes.'));
          }
          return ListView.separated(
            itemCount: pendientes.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final item = pendientes[index];
              return ListTile(
                title: Text(
                  'Horas solicitadas: ${item['cantidad_horas_extra_solicitadas']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Motivo: ${item['motivo']}'),
                    Text('Fecha: ${item['fecha_solicitud']}'),
                    Text('Solicitante ID: ${item['empleado_solicitador']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                      onPressed: () async {
                        final response =
                            await ApiService.responderSolicitudHorasExtras(
                          id: item['id'],
                          aprobado: true,
                        );
                        if (mounted) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(response['mensaje'] ??
                                    'Solicitud aprobada')),
                          );
                          setState(() {
                            _pendientesFuture = _fetchPendientes();
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () async {
                        final response =
                            await ApiService.responderSolicitudHorasExtras(
                          id: item['id'],
                          aprobado: false,
                        );
                        if (mounted) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(response['mensaje'] ??
                                    'Solicitud rechazada')),
                          );
                          setState(() {
                            _pendientesFuture = _fetchPendientes();
                          });
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
