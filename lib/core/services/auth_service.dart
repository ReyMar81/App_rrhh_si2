import 'dart:convert';
import 'package:http/http.dart' as http;
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

  /// Inicia sesión, guarda tokens y datos del empleado o jefe
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

    // Obtener user_id desde el token decodificado
    final decodedToken = JwtDecoder.decode(accessToken);
    final userId = decodedToken['user_id'];
    await prefs.setInt(_userIdKey, userId);

    // Intentar obtener datos del empleado vinculado al usuario
    final perfilUrl = Uri.parse('$apiBaseUrl/empleados/$userId/');
    final perfilResp = await http.get(
      perfilUrl,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (perfilResp.statusCode == 200) {
      final empleado = jsonDecode(perfilResp.body);
      await prefs.setString(_userNameKey, empleado['nombre'] ?? 'Empleado');
      await prefs.setString(_userRolKey, empleado['cargo'] ?? 'empleado');
      await prefs.setInt(_empleadoIdKey, empleado['id']);
    } else {
      // Si no tiene perfil de empleado, asumir que es un jefe
      await prefs.setString(_userNameKey, 'Jefe');
      await prefs.setString(_userRolKey, 'admin');
    }

    return true;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userRolKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_empleadoIdKey);
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
      return true;
    }

    return false;
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  static Future<String?> getUserRol() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRolKey);
  }

  static Future<int?> getEmpleadoId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_empleadoIdKey);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }
}
