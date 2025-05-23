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
      final empleadoId = prefs.getInt('empleado_id');
      if (empleadoId == null) throw Exception('ID del empleado no disponible');

      final data = await ApiService.obtenerEmpleadoPorId(empleadoId);
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

  Widget _infoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _empleado == null
              ? const Center(child: Text("No se pudo cargar el perfil"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "${_empleado!.nombre} ${_empleado!.apellidos}",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              _empleado!.cargo ?? 'Sin cargo asignado',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const Divider(height: 30, thickness: 1.2),
                          _infoItem(
                              Icons.badge, "CI", _empleado!.ci.toString()),
                          _infoItem(
                              Icons.cake,
                              "Fecha de nacimiento",
                              _empleado!.fechaNacimiento != null
                                  ? _empleado!.fechaNacimiento!
                                      .toString()
                                      .split(' ')[0]
                                  : "-"),
                          _infoItem(Icons.email, "Correo",
                              _empleado!.correoPersonal ?? "-"),
                          _infoItem(
                              Icons.phone, "Teléfono", _empleado!.telefono),
                          _infoItem(Icons.location_on, "Dirección",
                              _empleado!.direccion ?? "-"),
                          _infoItem(
                              Icons.family_restroom,
                              "Estado civil",
                              _empleado!.estadoCivil == "S"
                                  ? 'Soltero'
                                  : _empleado!.estadoCivil == "C"
                                      ? 'Casado'
                                      : _empleado!.estadoCivil == "V"
                                          ? 'Viudo'
                                          : "-"),
                          _infoItem(
                              Icons.calendar_today,
                              "Fecha de ingreso",
                              // ignore: unnecessary_null_comparison
                              _empleado!.fechaIngreso != null
                                  ? _empleado!.fechaIngreso
                                      .toString()
                                      .split(' ')[0]
                                  : "-"),
                          _infoItem(
                              Icons.male,
                              "Género",
                              _empleado!.genero == 'M'
                                  ? 'Masculino'
                                  : 'Femenino'),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
