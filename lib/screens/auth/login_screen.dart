import 'package:flutter/material.dart';
import 'package:mobile_app/config/constants.dart';
import 'package:mobile_app/core/services/auth_service.dart';
import 'package:mobile_app/routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _verPassword = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final success = await AuthService.login(
      username: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      final esPrimerIngreso = await AuthService.isPrimerIngreso();

      if (esPrimerIngreso) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, AppRoutes.cambiarPasswordFinal);
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } else {
      setState(() => _error = 'Credenciales inválidas o error de conexión');
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Bienvenido a la App',
                  style: headerStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: 'Nombre de usuario',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 20),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: !_verPassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      hintText: 'Contraseña',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _verPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _verPassword = !_verPassword;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_error != null) ...[
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                  const SizedBox(height: 20),
                ],
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: elevatedButtonStyle,
                    onPressed: _loading ? null : _login,
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Iniciar sesión', style: buttonTextStyle),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
