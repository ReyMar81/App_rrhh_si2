import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/core/models/asistencia.dart';
import 'package:mobile_app/core/models/cargo.dart';
import 'package:mobile_app/core/models/departamento.dart';
import 'package:mobile_app/core/models/documento.dart';
import 'package:mobile_app/core/models/empleado_por_departamento.dart';
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
        throw Exception(
            'Error ${response.statusCode}: ${data['detail'] ?? 'Error desconocido'}');
      } catch (_) {
        throw Exception('Error ${response.statusCode}: Respuesta no válida');
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
    return await post('asistencia/registrar/', {});
  }

// Obtener historial de asistencias
  static Future<List<Asistencia>> obtenerMisAsistencias() async {
    final data = await get('asistencia/mis_asistencias/');
    return data.map<Asistencia>((json) => Asistencia.fromJson(json)).toList();
  }

// Obtener estado de asistencia
  static Future<Map<String, dynamic>> obtenerEstadoAsistenciaHoy() async {
    return await get('asistencia/estado_asistencia/');
  }
}
