class Departamento {
  final int id;
  final String nombre;
  final String descripcion;
  final DateTime fechaCreacion;

  Departamento({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.fechaCreacion,
  });

  factory Departamento.fromJson(Map<String, dynamic> json) {
    return Departamento(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
        'fecha_creacion': fechaCreacion.toIso8601String(),
      };
}
