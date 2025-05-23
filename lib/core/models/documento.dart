class Documento {
  final int id;
  final String titulo;
  final String url;
  final DateTime fechaSubida;
  final DateTime fechaModificacion;
  final int tipoId;
  final int categoriaId;
  final int empleadoId;
  final int? contratoId;

  Documento({
    required this.id,
    required this.titulo,
    required this.url,
    required this.fechaSubida,
    required this.fechaModificacion,
    required this.tipoId,
    required this.categoriaId,
    required this.empleadoId,
    this.contratoId,
  });

  factory Documento.fromJson(Map<String, dynamic> json) => Documento(
        id: json['id'],
        titulo: json['titulo'],
        url: json['url'],
        fechaSubida: DateTime.parse(json['fecha_subida']),
        fechaModificacion: DateTime.parse(json['fecha_modificacion']),
        tipoId: json['tipo_id'],
        categoriaId: json['categoria_id'],
        empleadoId: json['empleado_id'],
        contratoId: json['contrato_id'],
      );
}
