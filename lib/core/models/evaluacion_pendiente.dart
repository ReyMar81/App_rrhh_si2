class EvaluacionPendiente {
  final int id;
  final int evaluado;
  final String evaluadoNombre;
  final int solicitador;
  final String solicitadorNombre;
  final String motivo;
  final String estado;
  final DateTime? fechaCreacion;

  EvaluacionPendiente({
    required this.id,
    required this.evaluado,
    required this.evaluadoNombre,
    required this.solicitador,
    required this.solicitadorNombre,
    required this.motivo,
    required this.estado,
    this.fechaCreacion,
  });

  factory EvaluacionPendiente.fromJson(Map<String, dynamic> json) {
    return EvaluacionPendiente(
      id: json['id'],
      evaluado: json['evaluado'],
      evaluadoNombre: json['evaluado_nombre'],
      solicitador: json['solicitador'],
      solicitadorNombre: json['solicitador_nombre'],
      motivo: json['motivo'],
      estado: json['estado'],
      fechaCreacion: json['fecha_creacion'] != null
          ? DateTime.tryParse(json['fecha_creacion'])
          : null,
    );
  }
}
