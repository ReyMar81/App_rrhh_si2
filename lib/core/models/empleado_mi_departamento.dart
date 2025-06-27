class EmpleadoMiDepartamento {
  final int id;
  final String cargo;
  final String nombre;
  final String apellidos;
  final int ci;
  final String fechaNacimiento;
  final String genero;
  final String direccion;
  final String estadoCivil;
  final String telefono;
  final String fechaIngreso;
  final String correoPersonal;
  final String cuentaBancaria;
  final int userId;

  EmpleadoMiDepartamento({
    required this.id,
    required this.cargo,
    required this.nombre,
    required this.apellidos,
    required this.ci,
    required this.fechaNacimiento,
    required this.genero,
    required this.direccion,
    required this.estadoCivil,
    required this.telefono,
    required this.fechaIngreso,
    required this.correoPersonal,
    required this.cuentaBancaria,
    required this.userId,
  });

  factory EmpleadoMiDepartamento.fromJson(Map<String, dynamic> json) {
    return EmpleadoMiDepartamento(
      id: json['id'],
      cargo: json['cargo'],
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
      cuentaBancaria: json['cuenta_bancaria'],
      userId: json['user_id'],
    );
  }
}
