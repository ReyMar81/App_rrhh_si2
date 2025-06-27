class Criterio {
  final int id;
  final String nombre;
  final String descripcion;

  Criterio({
    required this.id,
    required this.nombre,
    required this.descripcion,
  });

  factory Criterio.fromJson(Map<String, dynamic> json) {
    return Criterio(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }
}
