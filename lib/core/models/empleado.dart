class Empleado {
  final int id;
  final String nombre;
  final String apellidos;
  final int ci;
  final String? fechaNacimiento;
  final String? genero;
  final String? direccion;
  final String? estadoCivil;
  final String telefono;
  final String? fechaIngreso;
  final String? correoPersonal;
  final int userId;
  final String? cargo;

  Empleado({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.ci,
    this.fechaNacimiento,
    this.genero,
    this.direccion,
    this.estadoCivil,
    required this.telefono,
    this.fechaIngreso,
    this.correoPersonal,
    required this.userId,
    this.cargo,
  });

  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      id: json['id'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      ci: json['ci'],
      fechaNacimiento: json['fecha_nacimiento'],
      genero: json['genero'],
      direccion: json['direccion'],
      estadoCivil: json['estado_civil'],
      telefono: json['telefono'],
      fechaIngreso: json['fecha_ingreso'],
      correoPersonal: json['correo_personal'],
      userId: json['user_id'],
      cargo: json['cargo'],
    );
  }
}
