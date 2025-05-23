import 'package:flutter/material.dart';
import 'package:mobile_app/config/constants.dart';
import 'package:mobile_app/core/models/departamento.dart';
import 'package:mobile_app/core/models/empleado_por_departamento.dart';
import 'package:mobile_app/core/services/api_service.dart';

class DepartamentosEmpleadosScreen extends StatefulWidget {
  const DepartamentosEmpleadosScreen({super.key});

  @override
  State<DepartamentosEmpleadosScreen> createState() =>
      _DepartamentosEmpleadosScreenState();
}

class _DepartamentosEmpleadosScreenState
    extends State<DepartamentosEmpleadosScreen> {
  List<Departamento> _departamentos = [];
  List<EmpleadoPorDepartamento> _empleados = [];
  int? _departamentoSeleccionado;
  bool _loading = true;
  bool _loadingEmpleados = false;

  @override
  void initState() {
    super.initState();
    _cargarDepartamentos();
  }

  Future<void> _cargarDepartamentos() async {
    try {
      final data = await ApiService.obtenerDepartamentos();
      setState(() => _departamentos = data);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar departamentos: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _verEmpleados(int departamentoId) async {
    setState(() {
      _loadingEmpleados = true;
      _departamentoSeleccionado = departamentoId;
      _empleados = [];
    });

    try {
      final data =
          await ApiService.obtenerEmpleadosPorDepartamento(departamentoId);
      setState(() => _empleados = data);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar empleados: $e')),
      );
    } finally {
      setState(() => _loadingEmpleados = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empleados por Departamento'),
        backgroundColor: primaryColor,
      ),
      backgroundColor: backgroundColor,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: _departamentos.length,
                    itemBuilder: (context, index) {
                      final depto = _departamentos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        elevation: 3,
                        child: ListTile(
                          title: Text(depto.nombre),
                          subtitle: Text(depto.descripcion),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => _verEmpleados(depto.id),
                        ),
                      );
                    },
                  ),
                ),
                if (_departamentoSeleccionado != null) ...[
                  const Divider(thickness: 1.5),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Empleados del departamento",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  _loadingEmpleados
                      ? const CircularProgressIndicator()
                      : Expanded(
                          flex: 1,
                          child: _empleados.isEmpty
                              ? const Center(
                                  child: Text(
                                      "No hay empleados en este departamento"))
                              : ListView.builder(
                                  itemCount: _empleados.length,
                                  itemBuilder: (context, index) {
                                    final emp = _empleados[index];
                                    return ListTile(
                                      title: Text(emp.nombreCompleto),
                                      subtitle: Text("Cargo: ${emp.cargo}"),
                                      trailing: Text(emp.estado),
                                      leading: const Icon(Icons.person_outline),
                                    );
                                  },
                                ),
                        ),
                ],
              ],
            ),
    );
  }
}
