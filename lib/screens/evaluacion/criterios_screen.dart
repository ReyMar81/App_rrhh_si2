import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/criterio.dart';
import 'package:mobile_app/core/models/resultado_evaluacion.dart';
import 'package:mobile_app/core/services/api_service.dart';

class CriteriosScreen extends StatefulWidget {
  const CriteriosScreen({super.key});

  @override
  State<CriteriosScreen> createState() => _CriteriosScreenState();
}

class _CriteriosScreenState extends State<CriteriosScreen> {
  late Future<List<Criterio>> _criteriosFuture;
  late Future<List<ResultadoEvaluacion>> _resultadosFuture;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      final int evaluacionId =
          ModalRoute.of(context)!.settings.arguments as int;
      _criteriosFuture = ApiService.obtenerCriteriosNoEvaluados(evaluacionId);
      _resultadosFuture = ApiService.obtenerResultadosEvaluacion(evaluacionId);
      _isLoaded = true;
    }
  }

  void _recargar(int evaluacionId) {
    setState(() {
      _criteriosFuture = ApiService.obtenerCriteriosNoEvaluados(evaluacionId);
      _resultadosFuture = ApiService.obtenerResultadosEvaluacion(evaluacionId);
    });
  }

  void _mostrarModalCriterio(
      BuildContext context, Criterio criterio, int evaluacionId) {
    final comentarioController = TextEditingController();
    String? puntajeSeleccionado;

    final puntajeChoices = [
      {'value': 'excelente', 'label': 'EXCELENTE'},
      {'value': 'bueno', 'label': 'BUENO'},
      {'value': 'regular', 'label': 'REGULAR'},
      {'value': 'malo', 'label': 'MALO'},
      {'value': 'pesimo', 'label': 'PESIMO'},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar puntaje: ${criterio.nombre}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(criterio.descripcion),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: puntajeSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Puntaje',
                  border: OutlineInputBorder(),
                ),
                items: puntajeChoices
                    .map((choice) => DropdownMenuItem(
                          value: choice['value'],
                          child: Text(choice['label']!),
                        ))
                    .toList(),
                onChanged: (value) {
                  puntajeSeleccionado = value;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: comentarioController,
                decoration: const InputDecoration(
                  labelText: 'Comentario (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (puntajeSeleccionado == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Seleccione un puntaje')),
                  );
                  return;
                }
                await ApiService.agregarCriterioAEvaluacion(
                  evaluacionId: evaluacionId,
                  criterioId: criterio.id,
                  puntaje: puntajeSeleccionado!,
                  comentario: comentarioController.text,
                );
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                _recargar(evaluacionId); // <-- recarga la lista
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Puntaje agregado')),
                );
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int evaluacionId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criterios de Evaluación'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Nuevo Criterio',
            onPressed: () => _mostrarModalNuevoCriterio(context, evaluacionId),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: FutureBuilder<List<Criterio>>(
              future: _criteriosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final criterios = snapshot.data ?? [];
                if (criterios.isEmpty) {
                  return const Center(
                      child: Text('No hay criterios por evaluar.'));
                }
                return ListView.separated(
                  itemCount: criterios.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final criterio = criterios[index];
                    return ListTile(
                      title: Text(criterio.nombre),
                      subtitle: Text(criterio.descripcion),
                      trailing: const Icon(Icons.playlist_add_check),
                      onTap: () => _mostrarModalCriterio(
                          context, criterio, evaluacionId),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(thickness: 2),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Criterios ya evaluados",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 1,
            child: FutureBuilder<List<ResultadoEvaluacion>>(
              future: _resultadosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final resultados = snapshot.data ?? [];
                if (resultados.isEmpty) {
                  return const Center(
                      child: Text('Aún no hay criterios evaluados.'));
                }
                return ListView.separated(
                  itemCount: resultados.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final r = resultados[index];
                    return ListTile(
                      title: Text(r.criterioNombre),
                      subtitle: Text(
                        'Puntaje: ${r.puntaje}\n'
                        'Comentario: ${r.comentario?.isNotEmpty == true ? r.comentario : "-"}',
                      ),
                      leading:
                          const Icon(Icons.check_circle, color: Colors.green),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.flag),
              label: const Text('Finalizar Evaluación'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () async {
                final comentarioController = TextEditingController();
                final result = await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Comentario final'),
                    content: TextField(
                      controller: comentarioController,
                      decoration: const InputDecoration(
                        labelText: 'Comentario general (opcional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(
                            context, comentarioController.text.trim()),
                        child: const Text('Finalizar'),
                      ),
                    ],
                  ),
                );
                if (result != null) {
                  await ApiService.finalizarEvaluacion(
                    evaluacionId: evaluacionId,
                    comentarioGeneral: result,
                  );
                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('¡Evaluación finalizada!')),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, true);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarModalNuevoCriterio(BuildContext context, int evaluacionId) {
    final nombreController = TextEditingController();
    final descripcionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo Criterio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nombre = nombreController.text.trim();
                final descripcion = descripcionController.text.trim();
                if (nombre.isEmpty || descripcion.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Completa todos los campos')),
                  );
                  return;
                }
                await ApiService.postCriterio(
                  nombre: nombre,
                  descripcion: descripcion,
                );
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                _recargar(evaluacionId);
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Criterio creado')),
                );
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
