import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/config/constants.dart';
import 'package:mobile_app/core/services/api_service.dart';
import 'package:mobile_app/core/models/empleado.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Empleado? _empleado;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        throw Exception('ID de usuario no disponible');
      }

      final data = await ApiService.obtenerEmpleadoPorId(userId);
      final empleado = Empleado.fromJson(data);

      setState(() => _empleado = empleado);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar perfil: $e'),
            backgroundColor: errorColor,
          ),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Mi Perfil', style: headerStyle),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _empleado == null
              ? const Center(child: Text('No se pudo cargar el perfil'))
              : Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_empleado!.nombre} ${_empleado!.apellidos}',
                                style: headerStyle.copyWith(fontSize: 22),
                              ),
                              const SizedBox(height: 8),
                              Text('CI: ${_empleado!.ci}', style: labelStyle),
                              Text(
                                  'Correo: ${_empleado!.correoPersonal ?? '-'}',
                                  style: labelStyle),
                              Text('Teléfono: ${_empleado!.telefono}',
                                  style: labelStyle),
                              Text('Dirección: ${_empleado!.direccion ?? '-'}',
                                  style: labelStyle),
                              Text('Género: ${_empleado!.genero ?? '-'}',
                                  style: labelStyle),
                              Text(
                                  'Estado Civil: ${_empleado!.estadoCivil ?? '-'}',
                                  style: labelStyle),
                              Text('Cargo: ${_empleado!.cargo ?? '-'}',
                                  style: labelStyle),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: elevatedButtonStyle,
                          onPressed: () {
                            Navigator.pushNamed(context, '/cambiar-password');
                          },
                          icon: const Icon(Icons.lock_outline),
                          label: const Text(
                            'Cambiar contraseña',
                            style: buttonTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
