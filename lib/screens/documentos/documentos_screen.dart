import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/config/constants.dart';
import 'package:mobile_app/core/services/api_service.dart';
import 'package:mobile_app/core/models/documento.dart';
import 'package:mobile_app/widgets/entidad_card.dart';

class DocumentosScreen extends StatefulWidget {
  const DocumentosScreen({super.key});

  @override
  State<DocumentosScreen> createState() => _DocumentosScreenState();
}

class _DocumentosScreenState extends State<DocumentosScreen> {
  List<Documento> _documentos = [];
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

      final data = await ApiService.obtenerDocumentos();
      final documentos =
          data.map<Documento>((d) => Documento.fromJson(d)).toList();

      setState(() {
        _documentos = documentos;
        _esRRHH = rol == 'rrhh';
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar documentos: $e'),
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
        title: const Text('Documentos', style: headerStyle),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _documentos.isEmpty
              ? const Center(
                  child: Text('No hay documentos disponibles.', style: labelStyle),
                )
              : Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: ListView.builder(
                    itemCount: _documentos.length,
                    itemBuilder: (context, index) {
                      final doc = _documentos[index];
                      return EntidadCard(
                        titulo: doc.nombre,
                        subtitulo: 'Tipo: ${doc.tipoDocumento}',
                        onTap: () {
                          // En el futuro: abrir documento o ver detalles
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
