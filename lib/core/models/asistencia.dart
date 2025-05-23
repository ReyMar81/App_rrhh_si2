class Asistencia {
  final int id;
  final String fecha;
  final String? horaEntrada;
  final String? horaSalida;
  final double? horasTrabajadas;
  final String observaciones;
  final int empleadoId;
  final String? nombreEmpleado;

  Asistencia({
    required this.id,
    required this.fecha,
    this.horaEntrada,
    this.horaSalida,
    this.horasTrabajadas,
    required this.observaciones,
    required this.empleadoId,
    this.nombreEmpleado,
  });

  factory Asistencia.fromJson(Map<String, dynamic> json) {
    return Asistencia(
      id: json['id'],
      fecha: json['fecha'],
      horaEntrada: json['hora_entrada'],
      horaSalida: json['hora_salida'],
      horasTrabajadas: json['horas_trabajadas'] != null
          ? double.tryParse(json['horas_trabajadas'].toString())
          : null,
      observaciones: json['observaciones'] ?? '',
      empleadoId: json['empleado'],
      nombreEmpleado: json['nombre_empleado'],
    );
  }
}
