import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/core/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/config/constants.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  static const String _accessTokenKey = 'access';
  static const String _refreshTokenKey = 'refresh';
  static const String _userNameKey = 'user_name';
  static const String _userRolKey = 'user_rol';
  static const String _userIdKey = 'user_id';
  static const String _empleadoIdKey = 'empleado_id';
  static const String _primerIngresoKey = 'primer_ingreso';

  /// Inicia sesión, guarda tokens y datos del usuario
  static Future<bool> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$apiBaseUrl/token/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode != 200) return false;

    final data = jsonDecode(response.body);
    final accessToken = data['access'];
    final refreshToken = data['refresh'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);

    // Decodificar el token para extraer datos
    final decodedToken = JwtDecoder.decode(accessToken);
    final userId = decodedToken['user_id'];
    final userRol = decodedToken['rol'] ?? 'empleado';
    final primerIngreso = decodedToken['cambio_password_pendiente'] ?? false;

    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_userRolKey, userRol);
    await prefs.setBool(_primerIngresoKey, primerIngreso);

    // Obtener nombre y empleado_id si es empleado
    final empleado = await ApiService.obtenerEmpleadoActual();
    if (empleado != null) {
      await prefs.setString(_userNameKey, empleado['nombre'] ?? 'Empleado');
      await prefs.setInt(_empleadoIdKey, empleado['id']);
    } else {
      await prefs.setString(_userNameKey, 'Usuario');
    }

    return true;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString(_refreshTokenKey);
    if (refreshToken == null) return false;

    final url = Uri.parse('$apiBaseUrl/token/refresh/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newAccess = data['access'];
      await prefs.setString(_accessTokenKey, newAccess);

      // También actualizar primerIngreso y rol del nuevo token
      final decodedToken = JwtDecoder.decode(newAccess);
      await prefs.setBool(_primerIngresoKey,
          decodedToken['cambio_password_pendiente'] ?? false);
      await prefs.setString(_userRolKey, decodedToken['rol'] ?? 'empleado');

      return true;
    }

    return false;
  }

  // Getters de datos guardados
  static Future<String?> getAccessToken() async =>
      (await SharedPreferences.getInstance()).getString(_accessTokenKey);

  static Future<String?> getUserName() async =>
      (await SharedPreferences.getInstance()).getString(_userNameKey);

  static Future<String?> getUserRol() async =>
      (await SharedPreferences.getInstance()).getString(_userRolKey);

  static Future<int?> getEmpleadoId() async =>
      (await SharedPreferences.getInstance()).getInt(_empleadoIdKey);

  static Future<int?> getUserId() async =>
      (await SharedPreferences.getInstance()).getInt(_userIdKey);

  static Future<bool> isPrimerIngreso() async =>
      (await SharedPreferences.getInstance()).getBool(_primerIngresoKey) ??
      false;
}
