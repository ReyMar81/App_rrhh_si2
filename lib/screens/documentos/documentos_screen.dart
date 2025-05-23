import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_app/core/models/documento.dart';
import 'package:mobile_app/core/services/api_service.dart';
import 'package:mobile_app/config/constants.dart';

class DocumentosScreen extends StatefulWidget {
  const DocumentosScreen({super.key});

  @override
  State<DocumentosScreen> createState() => _DocumentosScreenState();
}

class _DocumentosScreenState extends State<DocumentosScreen> {
  List<Documento> _documentos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarDocumentos();
  }

  Future<void> _cargarDocumentos() async {
    setState(() => _loading = true);
    try {
      final documentos = await ApiService.obtenerMisDocumentos();
      setState(() => _documentos = documentos);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar documentos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _abrirDocumento(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el documento')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Documentos'),
        backgroundColor: primaryColor,
      ),
      backgroundColor: backgroundColor,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _documentos.isEmpty
              ? const Center(child: Text('No se encontraron documentos.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _documentos.length,
                  itemBuilder: (context, index) {
                    final doc = _documentos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(Icons.description_outlined,
                            color: primaryColor),
                        title: Text(doc.titulo),
                        subtitle: Text(
                            "Subido: ${doc.fechaSubida.toLocal().toString().split(' ')[0]}"),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () => _abrirDocumento(doc.url),
                      ),
                    );
                  },
                ),
    );
  }
}
