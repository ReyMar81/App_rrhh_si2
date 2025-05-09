import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/config/constants.dart';
import 'package:mobile_app/core/services/api_service.dart';
import 'package:mobile_app/core/models/departamento.dart';
import 'package:mobile_app/widgets/entidad_card.dart';

class DepartamentosScreen extends StatefulWidget {
  const DepartamentosScreen({super.key});

  @override
  State<DepartamentosScreen> createState() => _DepartamentosScreenState();
}

class _DepartamentosScreenState extends State<DepartamentosScreen> {
  List<Departamento> _departamentos = [];
  bool _loading = true;
  bool _esRRHH = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final rol = prefs.getString('user_rol') ?? 'empleado';

      final data = await ApiService.obtenerDepartamentos();
      final departamentos =
          data.map<Departamento>((d) => Departamento.fromJson(d)).toList();

      setState(() {
        _departamentos = departamentos;
        _esRRHH = rol == 'rrhh';
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar departamentos: $e'),
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
        title: const Text('Departamentos', style: headerStyle),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _departamentos.isEmpty
              ? const Center(
                  child: Text('No hay departamentos registrados.', style: labelStyle),
                )
              : Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: ListView.builder(
                    itemCount: _departamentos.length,
                    itemBuilder: (context, index) {
                      final depto = _departamentos[index];
                      return EntidadCard(
                        titulo: depto.nombre,
                        subtitulo: depto.descripcion,
                        onTap: () {
                          // Ir a empleados por departamento
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
