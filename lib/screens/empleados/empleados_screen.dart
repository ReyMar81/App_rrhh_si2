import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/config/constants.dart';
import 'package:mobile_app/core/services/api_service.dart';
import 'package:mobile_app/core/models/empleado.dart';
import 'package:mobile_app/widgets/entidad_card.dart';

class EmpleadosScreen extends StatefulWidget {
  const EmpleadosScreen({super.key});

  @override
  State<EmpleadosScreen> createState() => _EmpleadosScreenState();
}

class _EmpleadosScreenState extends State<EmpleadosScreen> {
  List<Empleado> _empleados = [];
  bool _loading = true;
  bool _esRRHH = false;

  @override
  void initState() {
    super.initState();
    _cargarEmpleados();
  }

  Future<void> _cargarEmpleados() async {
    setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final rol = prefs.getString('user_rol') ?? 'empleado';

      final data = await ApiService.obtenerEmpleados();
      final empleados =
          data.map<Empleado>((e) => Empleado.fromJson(e)).toList();

      setState(() {
        _empleados = empleados;
        _esRRHH = rol == 'rrhh';
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar empleados: $e'),
          backgroundColor: errorColor,
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Empleados', style: headerStyle),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _empleados.isEmpty
              ? const Center(
                  child:
                      Text('No hay empleados registrados.', style: labelStyle),
                )
              : Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: ListView.builder(
                    itemCount: _empleados.length,
                    itemBuilder: (context, index) {
                      final emp = _empleados[index];
                      final nombreCompleto = '${emp.nombre} ${emp.apellidos}';
                      final cargo = emp.cargo ?? 'Sin cargo asignado';

                      return EntidadCard(
                        titulo: nombreCompleto,
                        subtitulo: cargo,
                        onTap: () {
                          // Futuro: ver detalles o estado de asistencia
                        },
                        onEditar: _esRRHH ? () {} : null,
                        onEliminar: _esRRHH ? () {} : null,
                        mostrarAcciones: _esRRHH,
                      );
                    },
                  ),
                ),
    );
  }
}
