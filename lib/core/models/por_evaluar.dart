class EvaluacionPorEvaluar {
  final int id;
  final String motivo;
  final DateTime? fechaCreacion;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final String estado;
  final String? comentarioGeneral;
  final int evaluador;
  final int evaluado;
  final int solicitador;
  final String evaluadoNombre;

  EvaluacionPorEvaluar({
    required this.id,
    required this.motivo,
    this.fechaCreacion,
    this.fechaInicio,
    this.fechaFin,
    required this.estado,
    this.comentarioGeneral,
    required this.evaluador,
    required this.evaluado,
    required this.solicitador,
    required this.evaluadoNombre,
  });

  factory EvaluacionPorEvaluar.fromJson(Map<String, dynamic> json) {
    return EvaluacionPorEvaluar(
      id: json['id'],
      motivo: json['motivo'],
      fechaCreacion: json['fecha_creacion'] != null
          ? DateTime.tryParse(json['fecha_creacion'])
          : null,
      fechaInicio: json['fecha_inicio'] != null
          ? DateTime.tryParse(json['fecha_inicio'])
          : null,
      fechaFin: json['fecha_fin'] != null
          ? DateTime.tryParse(json['fecha_fin'])
          : null,
      estado: json['estado'],
      comentarioGeneral: json['comentario_general'],
      evaluador: json['evaluador'],
      evaluado: json['evaluado'],
      solicitador: json['solicitador'],
      evaluadoNombre: json['evaluado_nombre'],
    );
  }
}
