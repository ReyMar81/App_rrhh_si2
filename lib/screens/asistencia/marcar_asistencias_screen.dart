import 'package:flutter/material.dart';
import 'package:mobile_app/config/constants.dart';
import 'package:mobile_app/core/services/api_service.dart';

class MarcarAsistenciaScreen extends StatefulWidget {
  const MarcarAsistenciaScreen({super.key});

  @override
  State<MarcarAsistenciaScreen> createState() => _MarcarAsistenciaScreenState();
}

class _MarcarAsistenciaScreenState extends State<MarcarAsistenciaScreen> {
  bool _loading = false;
  bool _yaFinalizado = false;
  String? _mensaje;

  @override
  void initState() {
    super.initState();
    _verificarEstado();
  }

  Future<void> _verificarEstado() async {
    try {
      final estado = await ApiService.obtenerEstadoAsistenciaHoy();
      setState(() {
        _yaFinalizado = estado['yaMarcoSalida'] ?? false;
        _mensaje = estado['mensaje'];
      });
    } catch (e) {
      setState(() => _mensaje = 'Error al verificar estado: $e');
    }
  }

  Future<void> _marcar() async {
    setState(() {
      _loading = true;
      _mensaje = null;
    });

    try {
      final response = await ApiService.marcarAsistencia();
      final mensaje = response['mensaje'] ?? 'Asistencia registrada.';

      setState(() {
        _mensaje = mensaje;
        if (mensaje.toLowerCase().contains('ya marcó') ||
            mensaje.toLowerCase().contains('salida')) {
          _yaFinalizado = true;
        }
      });
    } catch (e) {
      setState(() => _mensaje = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marcar Asistencia'),
        backgroundColor: primaryColor,
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _yaFinalizado ? Colors.grey : primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: const Icon(Icons.fingerprint),
                label: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        _yaFinalizado
                            ? 'Jornada finalizada'
                            : 'Marcar asistencia',
                        style: buttonTextStyle,
                      ),
                onPressed: _loading || _yaFinalizado ? null : _marcar,
              ),
              const SizedBox(height: 20),
              if (_mensaje != null)
                Text(
                  _mensaje!,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
