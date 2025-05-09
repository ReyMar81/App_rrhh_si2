class Empleado {
  final int id;
  final String nombre;
  final String apellidos;
  final int ci;
  final DateTime? fechaNacimiento;
  final String? genero;
  final String? direccion;
  final String? estadoCivil;
  final String telefono;
  final String? cargo;
  final DateTime fechaIngreso;
  final String? correoPersonal;
  final int? userId;
  final int? departamentoId;

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
    this.cargo,
    required this.fechaIngreso,
    this.correoPersonal,
    this.userId,
    this.departamentoId,
  });

  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      id: json['id'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      ci: json['ci'],
      fechaNacimiento: json['fecha_nacimiento'] != null
          ? DateTime.parse(json['fecha_nacimiento'])
          : null,
      genero: json['genero'],
      direccion: json['direccion'],
      estadoCivil: json['estado_civil'],
      telefono: json['telefono'],
      cargo: json['cargo'],
      fechaIngreso: DateTime.parse(json['fecha_ingreso']),
      correoPersonal: json['correo_personal'],
      userId: json['user_id'],
      departamentoId: json['departamento_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'apellidos': apellidos,
        'ci': ci,
        'fecha_nacimiento': fechaNacimiento?.toIso8601String(),
        'genero': genero,
        'direccion': direccion,
        'estado_civil': estadoCivil,
        'telefono': telefono,
        'cargo': cargo,
        'fecha_ingreso': fechaIngreso.toIso8601String(),
        'correo_personal': correoPersonal,
        'user_id': userId,
        'departamento_id': departamentoId,
      };
}
