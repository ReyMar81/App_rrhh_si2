import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/core/models/asistencia.dart';
import 'package:mobile_app/core/models/boleta.dart';
import 'package:mobile_app/core/models/cargo.dart';
import 'package:mobile_app/core/models/departamento.dart';
import 'package:mobile_app/core/models/documento.dart';
import 'package:mobile_app/core/models/empleado_por_departamento.dart';
import 'package:mobile_app/core/models/empleado_mi_departamento.dart';
import 'package:mobile_app/core/models/evaluacion_pendiente.dart';
import 'package:mobile_app/core/models/por_evaluar.dart';
import 'package:mobile_app/core/models/criterio.dart';
import 'package:mobile_app/core/models/resultado_evaluacion.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/config/constants.dart';
import 'package:mobile_app/core/services/auth_service.dart';

class ApiService {
  // Métodos genéricos
  static Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$apiBaseUrl/$endpoint');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return _handleResponse(response, retry: () => get(endpoint));
  }

  static Future<dynamic> post(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$apiBaseUrl/$endpoint');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    return _handleResponse(response, retry: () => post(endpoint, data));
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$apiBaseUrl/$endpoint');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    return _handleResponse(response, retry: () => put(endpoint, data));
  }

  static Future<dynamic> patch(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$apiBaseUrl/$endpoint');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    return _handleResponse(response, retry: () => patch(endpoint, data));
  }

  static Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse('$apiBaseUrl/$endpoint');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return _handleResponse(response, retry: () => delete(endpoint));
  }

  // Manejo de respuestas y errores
  static Future<dynamic> _handleResponse(http.Response response,
      {Function? retry}) async {
    if (response.statusCode == 204) return null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        return jsonDecode(response.body);
      } catch (_) {
        throw Exception('Respuesta no válida:\n${response.body}');
      }
    } else if (response.statusCode == 401 && retry != null) {
      final refreshed = await AuthService.refreshAccessToken();
      if (refreshed) {
        return await retry();
      } else {
        await AuthService.logout();
        throw Exception('Sesión expirada. Inicia sesión nuevamente.');
      }
    } else {
      try {
        final data = jsonDecode(response.body);
        if (data is Map && data.containsKey('error')) {
          throw jsonEncode(data);
        }
        throw Exception(
            'Error ${response.statusCode}: ${data['detail'] ?? data.toString()}');
      } catch (_) {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    }
  }

  // ============================
  // FUNCIONES PARA LOS ENDPOINTS
  // ============================

  // Departamentos
  static Future<List<Departamento>> obtenerDepartamentos() async {
    final data = await get('departamentos/');
    return data
        .map<Departamento>((json) => Departamento.fromJson(json))
        .toList();
  }

// Obtener cargos por departamento
  static Future<List<Cargo>> obtenerCargosPorDepartamento(
      int departamentoId) async {
    final data = await get('departamentos/$departamentoId/cargos/');
    return data.map<Cargo>((json) => Cargo.fromJson(json)).toList();
  }

// Obtener empleados por departamento
  static Future<List<EmpleadoPorDepartamento>> obtenerEmpleadosPorDepartamento(
      int id) async {
    final data = await get('departamentos/$id/empleados/');
    return data
        .map<EmpleadoPorDepartamento>(
            (json) => EmpleadoPorDepartamento.fromJson(json))
        .toList();
  }

  // Documentos
  static Future<List<dynamic>> obtenerDocumentos() async =>
      await get('documentos/');

  // Empleados
  static Future<List<dynamic>> obtenerEmpleados() async =>
      await get('empleados/');

  static Future<Map<String, dynamic>> obtenerEmpleadoPorId(int id) async =>
      await get('empleados/$id/');

  static Future<Map<String, dynamic>?> obtenerEmpleadoActual() async {
    return await get('empleados/actual/');
  }

  static Future<List<Documento>> obtenerMisDocumentos() async {
    final data = await get('documentos/mios/');
    return data.map<Documento>((json) => Documento.fromJson(json)).toList();
  }

  static Future<Map<String, dynamic>> cambiarPasswordEmpleado({
    required int empleadoId,
    required String actualPassword,
    required String nuevaPassword,
  }) async {
    final response = await put(
      'empleados/$empleadoId/cambiar_password/',
      {
        'actual_password': actualPassword,
        'nueva_password': nuevaPassword,
      },
    );
    return response;
  }

// Marcar entrada o salida
  static Future<Map<String, dynamic>> marcarAsistencia() async {
    return await post('registrar/', {});
  }

// Obtener historial de asistencias
  static Future<List<Asistencia>> obtenerMisAsistencias() async {
    final data = await get('mis_asistencias/');
    return data.map<Asistencia>((json) => Asistencia.fromJson(json)).toList();
  }

// Obtener estado de asistencia
  static Future<Map<String, dynamic>> obtenerEstadoAsistenciaHoy() async {
    return await get('estado_asistencia/');
  }

  // Boletas
  static Future<List<Boleta>> obtenerBoletasPorEmpleado(int empleadoId) async {
    final data = await get('boletas-empleado/$empleadoId/');
    return data.map<Boleta>((json) => Boleta.fromJson(json)).toList();
  }

  // Solicitar horas extras
  static Future<Map<String, dynamic>> solicitarHorasExtras({
    required String cantidadHoras,
    required String motivo,
  }) async {
    return await post(
      'horas_extras/solicitar/',
      {
        'cantidad_horas_extra_solicitadas': cantidadHoras,
        'motivo': motivo,
      },
    );
  }

  // Aprobar o rechazar solicitud de horas extras
  static Future<Map<String, dynamic>> responderSolicitudHorasExtras({
    required int id,
    required bool aprobado,
  }) async {
    return await patch(
      'horas_extras/$id/responder/',
      {'aprobado': aprobado},
    );
  }

  // Obtener horas extras pendientes por aprobar
  static Future<List<dynamic>> obtenerHorasExtrasPendientes() async {
    final data = await get('horas_extras/pendientes-aprobar/');
    return data as List<dynamic>;
  }

  // Obtener empleados de mi departamento (usuario autenticado)
  static Future<List<EmpleadoMiDepartamento>>
      obtenerEmpleadosMiDepartamento() async {
    final data = await get('empleados/mi-departamento/empleados/');
    return data
        .map<EmpleadoMiDepartamento>(
            (json) => EmpleadoMiDepartamento.fromJson(json))
        .toList();
  }

// Solicitar evaluación
  static Future<Map<String, dynamic>> solicitarEvaluacion({
    required int evaluado,
    required String motivo,
  }) async {
    return await post(
      'evaluaciones/solicitar/',
      {
        'evaluado': evaluado,
        'motivo': motivo,
      },
    );
  }

  // Obtener evaluaciones pendientes por evaluar
  static Future<List<EvaluacionPendiente>>
      obtenerEvaluacionesPendientesEvaluar() async {
    final data = await get('evaluaciones/pendientes-evaluar/');
    return data
        .map<EvaluacionPendiente>((json) => EvaluacionPendiente.fromJson(json))
        .toList();
  }

  // Obtener evaluaciones en proceso de un aprobador
  static Future<List<EvaluacionPorEvaluar>>
      obtenerEvaluacionesPorEvaluar() async {
    final data =
        await get('evaluaciones/evaluacionesde-un-aprobador-en-proceso/');
    return data
        .map<EvaluacionPorEvaluar>(
            (json) => EvaluacionPorEvaluar.fromJson(json))
        .toList();
  }

  // Aceptar evaluación
  static Future<Map<String, dynamic>> aceptarEvaluacion({
    required int id,
  }) async {
    return await patch(
      'evaluaciones/$id/aceptar/',
      {},
    );
  }

// Crear un nuevo criterio de evaluación
  static Future<void> postCriterio({
    required String nombre,
    required String descripcion,
  }) async {
    await post(
      'criterios/',
      {
        'nombre': nombre,
        'descripcion': descripcion,
      },
    );
  }

// Agregar criterio a una evaluación
  static Future<void> agregarCriterioAEvaluacion({
    required int evaluacionId,
    required int criterioId,
    required String puntaje,
    String? comentario,
  }) async {
    await post(
      'evaluaciones/$evaluacionId/agregar-criterio/',
      {
        'criterio_id': criterioId,
        'puntaje': puntaje,
        'comentario': comentario ?? '',
      },
    );
  }

  static Future<List<Criterio>> obtenerCriteriosNoEvaluados(
      int evaluacionId) async {
    final data =
        await get('evaluaciones/$evaluacionId/criterios-no-evaluados/');
    return data.map<Criterio>((json) => Criterio.fromJson(json)).toList();
  }

  static Future<List<ResultadoEvaluacion>> obtenerResultadosEvaluacion(
      int evaluacionId) async {
    final data = await get('evaluaciones/$evaluacionId/resultados/');
    return data
        .map<ResultadoEvaluacion>((json) => ResultadoEvaluacion.fromJson(json))
        .toList();
  }

  static Future<void> finalizarEvaluacion({
    required int evaluacionId,
    required String comentarioGeneral,
  }) async {
    await patch(
      'evaluaciones/$evaluacionId/finalizar/',
      {
        'comentario_general': comentarioGeneral,
      },
    );
  }
}
