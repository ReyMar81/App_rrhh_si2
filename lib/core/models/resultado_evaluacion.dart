class ResultadoEvaluacion {
  final int id;
  final int criterioId;
  final String criterioNombre;
  final String criterioDescripcion;
  final String puntaje;
  final String? comentario;

  ResultadoEvaluacion({
    required this.id,
    required this.criterioId,
    required this.criterioNombre,
    required this.criterioDescripcion,
    required this.puntaje,
    this.comentario,
  });

  factory ResultadoEvaluacion.fromJson(Map<String, dynamic> json) {
    return ResultadoEvaluacion(
      id: json['id'],
      criterioId: json['criterio'],
      criterioNombre: json['criterio_nombre'],
      criterioDescripcion: json['criterio_descripcion'],
      puntaje: json['puntaje'],
      comentario: json['comentario'],
    );
  }
}
