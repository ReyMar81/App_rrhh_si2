import 'package:flutter/material.dart';
import 'package:mobile_app/screens/auth/login_screen.dart';
import 'package:mobile_app/screens/dashboard/home_screen.dart';
import 'package:mobile_app/screens/perfil/perfil_screen.dart';
import 'package:mobile_app/screens/documentos/documentos_screen.dart';
import 'package:mobile_app/screens/auth/cambiar_password_screen.dart';
import 'package:mobile_app/screens/departamentos/departamentos_screen.dart';
import 'package:mobile_app/screens/empleados/empleados_screen.dart';
import 'package:mobile_app/screens/asistencia/tomar_asistencia_screen.dart';
import 'package:mobile_app/screens/asistencia/asistencias_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const registro = '/registro';
  static const home = '/home';
  static const perfil = '/perfil';
  static const documentos = '/documentos';
  static const cambiarPassword = '/cambiar-password';
  static const departamentos = '/departamentos';
  static const empleadosPorDepto = '/empleados';
  static const tomarAsistencia = '/tomar-asistencia';
  static const asistenciasHoy = '/asistencias-hoy';

  static Map<String, WidgetBuilder> get routes => {
        login: (_) => const LoginScreen(),
        home: (_) => const HomeScreen(),
        perfil: (_) => const PerfilScreen(),
        documentos: (_) => const DocumentosScreen(),
        cambiarPassword: (_) => const CambiarPasswordScreen(),
        departamentos: (_) => const DepartamentosScreen(),
        empleadosPorDepto: (_) => const EmpleadosScreen(),
        tomarAsistencia: (_) => const TomarAsistenciaScreen(),
        asistenciasHoy: (_) => const AsistenciasScreen(),
      };
}
