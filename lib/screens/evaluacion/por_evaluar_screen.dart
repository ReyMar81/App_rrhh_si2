import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/core/models/por_evaluar.dart';
import 'package:mobile_app/core/services/api_service.dart';
import 'package:mobile_app/routes/app_routes.dart';

class PorEvaluarScreen extends StatefulWidget {
  const PorEvaluarScreen({super.key});

  @override
  State<PorEvaluarScreen> createState() => _PorEvaluarScreenState();
}

class _PorEvaluarScreenState extends State<PorEvaluarScreen> {
  late Future<List<EvaluacionPorEvaluar>> _evaluacionesFuture;

  @override
  void initState() {
    super.initState();
    _evaluacionesFuture = ApiService.obtenerEvaluacionesPorEvaluar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Evaluaciones en Proceso')),
      body: FutureBuilder<List<EvaluacionPorEvaluar>>(
        future: _evaluacionesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final evaluaciones = snapshot.data ?? [];
          if (evaluaciones.isEmpty) {
            return const Center(child: Text('No hay evaluaciones en proceso.'));
          }
          return ListView.separated(
            itemCount: evaluaciones.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = evaluaciones[index];
              final fechaInicio = item.fechaInicio != null
                  ? DateFormat('yyyy-MM-dd').format(item.fechaInicio!)
                  : '';
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                elevation: 2,
                child: ListTile(
                  title: Text('Motivo: ${item.motivo}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Evaluado: ${item.evaluadoNombre}'),
                      Text('Fecha de inicio: $fechaInicio'),
                    ],
                  ),
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      AppRoutes.criterios,
                      arguments: item.id,
                    );
                    if (result == true) {
                      setState(() {
                        _evaluacionesFuture =
                            ApiService.obtenerEvaluacionesPorEvaluar();
                      });
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
