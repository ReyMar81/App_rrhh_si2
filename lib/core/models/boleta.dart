class BoletaDetalle {
  final String nombre;
  final String codigo;
  final String tipo;
  final double monto;
  final int secuencia;

  BoletaDetalle({
    required this.nombre,
    required this.codigo,
    required this.tipo,
    required this.monto,
    required this.secuencia,
  });

  factory BoletaDetalle.fromJson(Map<String, dynamic> json) {
    return BoletaDetalle(
      nombre: json['nombre'],
      codigo: json['codigo'],
      tipo: json['tipo'],
      monto: (json['monto'] as num).toDouble(),
      secuencia: json['secuencia'],
    );
  }
}

class Boleta {
  final int id;
  final String fechaInicio;
  final String fechaFin;
  final double totalNeto;
  final double totalIngresos;
  final double totalDeducciones;
  final String estado;
  final String modoGeneracion;
  final List<BoletaDetalle> detalles;

  Boleta({
    required this.id,
    required this.fechaInicio,
    required this.fechaFin,
    required this.totalNeto,
    required this.totalIngresos,
    required this.totalDeducciones,
    required this.estado,
    required this.modoGeneracion,
    required this.detalles,
  });

  factory Boleta.fromJson(Map<String, dynamic> json) {
    return Boleta(
      id: json['id'],
      fechaInicio: json['fecha_inicio'],
      fechaFin: json['fecha_fin'],
      totalNeto: (json['total_neto'] as num).toDouble(),
      totalIngresos: (json['total_ingresos'] as num).toDouble(),
      totalDeducciones: (json['total_deducciones'] as num).toDouble(),
      estado: json['estado'],
      modoGeneracion: json['modo_generacion'],
      detalles: (json['detalles'] as List)
          .map((d) => BoletaDetalle.fromJson(d))
          .toList(),
    );
  }
}
