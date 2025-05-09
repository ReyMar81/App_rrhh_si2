import 'package:flutter/material.dart';
import 'package:mobile_app/config/constants.dart';

class EntidadCard extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final VoidCallback? onTap;
  final VoidCallback? onEditar;
  final VoidCallback? onEliminar;
  final bool mostrarAcciones;

  const EntidadCard({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.onTap,
    this.onEditar,
    this.onEliminar,
    this.mostrarAcciones = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: defaultPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: headerStyle),
              if (subtitulo != null) ...[
                const SizedBox(height: 6),
                Text(subtitulo!, style: labelStyle),
              ],
              if (mostrarAcciones)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueGrey),
                      onPressed: onEditar,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: onEliminar,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
