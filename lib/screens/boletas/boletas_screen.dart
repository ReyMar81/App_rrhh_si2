import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/boleta.dart';
import 'package:mobile_app/core/services/api_service.dart';
import 'package:mobile_app/routes/app_routes.dart';

class BoletasScreen extends StatefulWidget {
  final int empleadoId;
  const BoletasScreen({super.key, required this.empleadoId});

  @override
  State<BoletasScreen> createState() => _BoletasScreenState();
}

class _BoletasScreenState extends State<BoletasScreen> {
  late Future<List<Boleta>> _futureBoletas;

  @override
  void initState() {
    super.initState();
    _futureBoletas = ApiService.obtenerBoletasPorEmpleado(widget.empleadoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Boletas de Pago')),
      body: FutureBuilder<List<Boleta>>(
        future: _futureBoletas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final boletas = snapshot.data ?? [];
          if (boletas.isEmpty) {
            return const Center(child: Text('No hay boletas disponibles.'));
          }
          return ListView.separated(
            itemCount: boletas.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final b = boletas[index];
              return ListTile(
                title: Text(
                  'Del ${b.fechaInicio} al ${b.fechaFin}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Neto: ${b.totalNeto} Bs'),
                    Text('Ingresos: ${b.totalIngresos} Bs'),
                    Text('Deducciones: ${b.totalDeducciones} Bs'),
                    Text('Estado: ${b.estado}'),
                  ],
                ),
                isThreeLine: true,
                leading: const Icon(Icons.receipt_long),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.boletaDetalle,
                    arguments: b, // boleta es el objeto seleccionado
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
