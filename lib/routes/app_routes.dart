import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/boleta.dart';
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
import 'package:mobile_app/screens/boletas/boletas_screen.dart';
import 'package:mobile_app/screens/boletas/boleta_detalle_screen.dart';
import 'package:mobile_app/screens/horas_extras/solicitud_screen.dart';
import 'package:mobile_app/screens/horas_extras/pendientes_screen.dart';
import 'package:mobile_app/screens/evaluacion/solicitud_screen.dart';
import 'package:mobile_app/screens/evaluacion/pendientes_screen.dart';
import 'package:mobile_app/screens/evaluacion/por_evaluar_screen.dart';
import 'package:mobile_app/screens/evaluacion/criterios_screen.dart';

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
  static const boletas = '/boletas';
  static const boletaDetalle = '/boleta-detalle';
  static const horasExtrasSolicitar = '/horas-extras-solicitar';
  static const horasExtrasPendientes = '/horas-extras-pendientes';
  static const evaluacionSolicitar = '/evaluacion-solicitar';
  static const evaluacionPendientes = '/evaluacion-pendientes';
  static const evaluacionPorEvaluar = '/evaluacion-por-evaluar';
  static const criterios = '/criterios';

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
        boletas: (context) {
          final empleadoId = ModalRoute.of(context)!.settings.arguments as int;
          return BoletasScreen(empleadoId: empleadoId);
        },
        boletaDetalle: (context) {
          final boleta = ModalRoute.of(context)!.settings.arguments as Boleta;
          return BoletaDetalleScreen(boleta: boleta);
        },
        horasExtrasSolicitar: (_) => const SolicitudHorasExtrasScreen(),
        horasExtrasPendientes: (_) => const PendientesHorasExtrasScreen(),
        evaluacionSolicitar: (_) => const SolicitudEvaluacionScreen(),
        evaluacionPendientes: (_) => const PendientesEvaluacionScreen(),
        evaluacionPorEvaluar: (_) => const PorEvaluarScreen(),
        criterios: (_) => const CriteriosScreen(),
      };
}
