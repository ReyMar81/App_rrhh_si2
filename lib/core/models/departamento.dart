class Departamento {
  final int id;
  final String nombre;
  final String descripcion;
  final List<SubDepartamento> subdepartamentos;

  Departamento({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.subdepartamentos,
  });

  factory Departamento.fromJson(Map<String, dynamic> json) {
    return Departamento(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      subdepartamentos: (json['subdepartamentos'] as List)
          .map((e) => SubDepartamento.fromJson(e))
          .toList(),
    );
  }
}

class SubDepartamento {
  final int id;
  final String nombre;
  final String descripcion;

  SubDepartamento({
    required this.id,
    required this.nombre,
    required this.descripcion,
  });

  factory SubDepartamento.fromJson(Map<String, dynamic> json) {
    return SubDepartamento(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }
}
