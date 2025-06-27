import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/boleta.dart';

class BoletaDetalleScreen extends StatelessWidget {
  final Boleta boleta;
  const BoletaDetalleScreen({super.key, required this.boleta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Boleta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Del ${boleta.fechaInicio} al ${boleta.fechaFin}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text('Neto: ${boleta.totalNeto} Bs'),
            Text('Ingresos: ${boleta.totalIngresos} Bs'),
            Text('Deducciones: ${boleta.totalDeducciones} Bs'),
            Text('Estado: ${boleta.estado}'),
            const Divider(height: 32),
            const Text('Detalles:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: boleta.detalles.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final d = boleta.detalles[index];
                  return ListTile(
                    title: Text(d.nombre),
                    subtitle: Text('Código: ${d.codigo} | Tipo: ${d.tipo}'),
                    trailing: Text('${d.monto} Bs'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}