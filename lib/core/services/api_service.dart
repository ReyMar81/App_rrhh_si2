import 'dart:convert';
import 'package:http/http.dart' as http;
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

  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
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

  static Future<dynamic> patch(String endpoint, Map<String, dynamic> data) async {
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
  static Future<dynamic> _handleResponse(http.Response response, {Function? retry}) async {
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
        throw Exception('Error ${response.statusCode}: ${data['detail'] ?? 'Error desconocido'}');
      } catch (_) {
        throw Exception('Error ${response.statusCode}: Respuesta no válida');
      }
    }
  }

  // ============================
  // FUNCIONES PARA LOS ENDPOINTS
  // ============================

  // Departamentos
  static Future<List<dynamic>> obtenerDepartamentos() async =>
      await get('departamentos/');

  // Documentos
  static Future<List<dynamic>> obtenerDocumentos() async =>
      await get('documentos/');

  // Empleados
  static Future<List<dynamic>> obtenerEmpleados() async =>
      await get('empleados/');

static Future<Map<String, dynamic>> obtenerEmpleadoPorId(int id) async =>
    await get('empleados/$id/');
}
