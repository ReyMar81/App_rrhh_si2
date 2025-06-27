import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/api_service.dart';

class SolicitudHorasExtrasScreen extends StatefulWidget {
  const SolicitudHorasExtrasScreen({super.key});

  @override
  State<SolicitudHorasExtrasScreen> createState() =>
      _SolicitudHorasExtrasScreenState();
}

class _SolicitudHorasExtrasScreenState
    extends State<SolicitudHorasExtrasScreen> {
  final _formKey = GlobalKey<FormState>();
  final _horasController = TextEditingController();
  final _motivoController = TextEditingController();
  bool _loading = false;

  Future<void> _enviarSolicitud() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final response = await ApiService.solicitarHorasExtras(
        cantidadHoras: _horasController.text.trim(),
        motivo: _motivoController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['mensaje'] ?? 'Solicitud enviada')),
        );
        _formKey.currentState!.reset();
        _horasController.clear();
        _motivoController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _horasController.dispose();
    _motivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar Horas Extras')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _horasController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad de horas (ej: 2:30)',
                  prefixIcon: Icon(Icons.timer),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese la cantidad de horas'
                    : null,
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
