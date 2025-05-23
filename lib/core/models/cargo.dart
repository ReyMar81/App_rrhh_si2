class Cargo {
  final int id;
  final String nombre;
  final String tipoPago;
  final String salario;

  Cargo({
    required this.id,
    required this.nombre,
    required this.tipoPago,
    required this.salario,
  });

  factory Cargo.fromJson(Map<String, dynamic> json) {
    return Cargo(
      id: json['id'],
      nombre: json['nombre'],
      tipoPago: json['tipo_pago'],
      salario: json['salario'],
    );
  }
}
