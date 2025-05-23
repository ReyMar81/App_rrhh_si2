class EmpleadoPorDepartamento {
  final int id;
  final String nombreCompleto;
  final String cargo;
  final String estado;

  EmpleadoPorDepartamento({
    required this.id,
    required this.nombreCompleto,
    required this.cargo,
    required this.estado,
  });

  factory EmpleadoPorDepartamento.fromJson(Map<String, dynamic> json) {
    return EmpleadoPorDepartamento(
      id: json['id'],
      nombreCompleto: json['nombre_completo'],
      cargo: json['cargo'],
      estado: json['estado'],
    );
  }
}
