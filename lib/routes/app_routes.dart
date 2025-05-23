import 'package:flutter/material.dart';
import 'package:mobile_app/screens/asistencia/marcar_asistencias_screen.dart';
import 'package:mobile_app/screens/asistencia/mis_asistencias_screen.dart';
import 'package:mobile_app/screens/auth/login_screen.dart';
import 'package:mobile_app/screens/dashboard/home_screen.dart';
import 'package:mobile_app/screens/departamentos/departamentos_empleados_screen.dart';
import 'package:mobile_app/screens/perfil/perfil_screen.dart';
import 'package:mobile_app/screens/documentos/documentos_screen.dart';
import 'package:mobile_app/screens/auth/cambiar_password_screen.dart';
import 'package:mobile_app/screens/departamentos/departamentos_cargos_screen.dart';
import 'package:mobile_app/screens/auth/cambiar_password_final_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const registro = '/registro';
  static const home = '/home';
  static const perfil = '/perfil';
  static const documentos = '/documentos';
  static const cambiarPassword = '/cambiar-password';
  static const departamentosEmpleados = '/departamentos-empleados';
  static const departamentosCargos = '/departamentos-cargos';
  static const marcarAsistencia = '/marcar-asistencia';
  static const misAsistencias = '/mis-asistencias';
  static const cambiarPasswordFinal = '/cambiar-password-final';

  static Map<String, WidgetBuilder> get routes => {
        login: (_) => const LoginScreen(),
        home: (_) => const HomeScreen(),
        perfil: (_) => const PerfilScreen(),
        documentos: (_) => const DocumentosScreen(),
        cambiarPassword: (_) => const CambiarPasswordScreen(),
        departamentosEmpleados: (_) => const DepartamentosEmpleadosScreen(),
        departamentosCargos: (_) => const DepartamentosCargosScreen(),
        marcarAsistencia: (_) => const MarcarAsistenciaScreen(),
        misAsistencias: (_) => const MisAsistenciasScreen(),
        cambiarPasswordFinal: (_) => const CambiarPasswordFinalScreen(),
      };
}
