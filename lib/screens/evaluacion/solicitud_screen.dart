import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/empleado_mi_departamento.dart';
import 'package:mobile_app/core/services/api_service.dart';

class SolicitudEvaluacionScreen extends StatefulWidget {
  const SolicitudEvaluacionScreen({super.key});

  @override
  State<SolicitudEvaluacionScreen> createState() =>
      _SolicitudEvaluacionScreenState();
}

class _SolicitudEvaluacionScreenState extends State<SolicitudEvaluacionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _motivoController = TextEditingController();
  bool _loading = false;
  int? _empleadoSeleccionado;
  List<EmpleadoMiDepartamento> _empleados = [];

  @override
  void initState() {
    super.initState();
    _cargarEmpleados();
  }

  Future<void> _cargarEmpleados() async {
    try {
      final empleados = await ApiService.obtenerEmpleadosMiDepartamento();
      setState(() => _empleados = empleados);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar empleados: $e')),
        );
      }
    }
  }

  Future<void> _enviarSolicitud() async {
    if (!_formKey.currentState!.validate() || _empleadoSeleccionado == null) {
      return;
    }
    setState(() => _loading = true);
    try {
      final response = await ApiService.solicitarEvaluacion(
        evaluado: _empleadoSeleccionado!,
        motivo: _motivoController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['mensaje'] ?? 'Solicitud enviada')),
        );
        _formKey.currentState!.reset();
        _motivoController.clear();
        setState(() => _empleadoSeleccionado = null);
      }
    } catch (e) {
      if (mounted) {
        String errorMsg = 'Ocurrió un error';
        String? errorStr;
        if (e is Exception) {
          errorStr = e.toString();
        } else if (e is String) {
          errorStr = e;
        }
        if (errorStr != null) {
          final jsonStart = errorStr.indexOf('{');
          if (jsonStart != -1) {
            final possibleJson = errorStr.substring(jsonStart);
            try {
              final decoded = json.decode(possibleJson);
              if (decoded is Map && decoded.containsKey('error')) {
                errorMsg = decoded['error'];
              } else {
                errorMsg = errorStr;
              }
            } catch (_) {
              errorMsg = errorStr;
            }
          } else {
            errorMsg = errorStr;
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _motivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar Evaluación')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: _empleadoSeleccionado,
                items: _empleados
                    .map((e) => DropdownMenuItem(
                          value: e.id,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              '${e.nombre} ${e.apellidos} (${e.cargo})',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _empleadoSeleccionado = value),
                decoration: const InputDecoration(
                  labelText: 'Empleado a evaluar',
                  prefixIcon: Icon(Icons.person_search),
                ),
                validator: (value) =>
                    value == null ? 'Seleccione un empleado' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _motivoController,
                decoration: const InputDecoration(
                  labelText: 'Motivo',
                  prefixIcon: Icon(Icons.edit_note),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese el motivo' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Solicitar'),
                  onPressed: _loading ? null : _enviarSolicitud,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
