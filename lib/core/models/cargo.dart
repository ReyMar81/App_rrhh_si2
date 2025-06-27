class Cargo {
  final int? id;
  final String? nombre;
  final String? tipoPago;
  final String? salario;
  final String? recesoDiario;
  final String? horarioInicio;
  final String? horarioFin;
  final String? fechaCreacion;
  final String? horasDeTrabajo;

  Cargo({
    this.id,
    this.nombre,
    this.tipoPago,
    this.salario,
    this.recesoDiario,
    this.horarioInicio,
    this.horarioFin,
    this.fechaCreacion,
    this.horasDeTrabajo,
  });

  factory Cargo.fromJson(Map<String, dynamic> json) {
    return Cargo(
      id: json['id'],
      nombre: json['nombre'],
      tipoPago: json['tipo_pago'],
      salario: json['salario']?.toString(),
      recesoDiario: json['receso_diario']?.toString(),
      horarioInicio: json['horario_inicio'],
      horarioFin: json['horario_fin'],
      fechaCreacion: json['fecha_creacion'],
      horasDeTrabajo: json['horas_de_trabajo']?.toString(),
    );
  }
}
