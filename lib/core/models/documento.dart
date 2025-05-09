class Documento {
  final int id;
  final String nombre;
  final String tipoDocumento;
  final String url;
  final DateTime fechaSubida;
  final DateTime fechaModificacion;
  final int empleadoId;

  Documento({
    required this.id,
    required this.nombre,
    required this.tipoDocumento,
    required this.url,
    required this.fechaSubida,
    required this.fechaModificacion,
    required this.empleadoId,
  });

  factory Documento.fromJson(Map<String, dynamic> json) {
    return Documento(
      id: json['id'],
      nombre: json['nombre'],
      tipoDocumento: json['tipo_documento'],
      url: json['url'],
      fechaSubida: DateTime.parse(json['fecha_subida']),
      fechaModificacion: DateTime.parse(json['fecha_modificacion']),
      empleadoId: json['empleado_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'tipo_documento': tipoDocumento,
        'url': url,
        'fecha_subida': fechaSubida.toIso8601String(),
        'fecha_modificacion': fechaModificacion.toIso8601String(),
        'empleado_id': empleadoId,
      };
}
