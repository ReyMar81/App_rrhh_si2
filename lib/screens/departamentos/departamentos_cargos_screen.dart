import 'package:flutter/material.dart';
import 'package:mobile_app/config/constants.dart';
import 'package:mobile_app/core/models/departamento.dart';
import 'package:mobile_app/core/models/cargo.dart';
import 'package:mobile_app/core/services/api_service.dart';

class DepartamentosCargosScreen extends StatefulWidget {
  const DepartamentosCargosScreen({super.key});

  @override
  State<DepartamentosCargosScreen> createState() =>
      _DepartamentosCargosScreenState();
}

class _DepartamentosCargosScreenState extends State<DepartamentosCargosScreen> {
  List<Departamento> _departamentos = [];
  List<Cargo> _cargos = [];
  int? _departamentoSeleccionado;
  bool _loading = true;
  bool _loadingCargos = false;

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

  Future<void> _verCargos(int departamentoId) async {
    setState(() {
      _loadingCargos = true;
      _departamentoSeleccionado = departamentoId;
      _cargos = [];
    });

    try {
      final data =
          await ApiService.obtenerCargosPorDepartamento(departamentoId);
      setState(() => _cargos = data);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar cargos: $e')),
      );
    } finally {
      setState(() => _loadingCargos = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargos por Departamento'),
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
                          onTap: () => _verCargos(depto.id),
                        ),
                      );
                    },
                  ),
                ),
                if (_departamentoSeleccionado != null) ...[
                  const Divider(thickness: 1.5),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Cargos disponibles",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  _loadingCargos
                      ? const CircularProgressIndicator()
                      : Expanded(
                          flex: 1,
                          child: _cargos.isEmpty
                              ? const Center(
                                  child: Text(
                                      "No hay cargos en este departamento"))
                              : ListView.builder(
                                  itemCount: _cargos.length,
                                  itemBuilder: (context, index) {
                                    final c = _cargos[index];
                                    return ListTile(
                                      title: Text(c.nombre ?? '-'),
                                      subtitle: Text(
                                          "Salario: ${c.salario ?? '-'} Bs | Pago: ${c.tipoPago ?? '-'}\n"
                                          "Horario: ${c.horarioInicio ?? '-'} - ${c.horarioFin ?? '-'} | "
                                          "Receso: ${c.recesoDiario ?? '-'}h | Horas: ${c.horasDeTrabajo ?? '-'}h"),
                                      leading: const Icon(Icons.work_outline),
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
