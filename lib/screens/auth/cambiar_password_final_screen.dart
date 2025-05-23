import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/config/constants.dart';
import 'package:mobile_app/core/services/api_service.dart';
import 'package:mobile_app/core/services/auth_service.dart';
import 'package:mobile_app/routes/app_routes.dart';

class CambiarPasswordFinalScreen extends StatefulWidget {
  const CambiarPasswordFinalScreen({super.key});

  @override
  State<CambiarPasswordFinalScreen> createState() =>
      _CambiarPasswordFinalScreenState();
}

class _CambiarPasswordFinalScreenState
    extends State<CambiarPasswordFinalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nuevaPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _loading = false;
  bool _verNueva = false;
  bool _verConfirm = false;
  bool _mostrarErrorCoincidencia = false;

  Future<void> _cambiarPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    try {
      final empleadoId = await AuthService.getEmpleadoId();
      if (empleadoId == null) {
        throw Exception('No se pudo obtener el ID del empleado');
      }

      final response = await ApiService.put(
        'empleados/$empleadoId/cambiar_password/',
        {
          'nueva_password': _nuevaPasswordController.text.trim(),
        },
      );

      if (response != null && response['mensaje'] != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contraseña cambiada. Inicia sesión nuevamente.'),
            backgroundColor: primaryColor,
          ),
        );

        await Future.delayed(const Duration(seconds: 2));
        await AuthService.logout();

        if (!mounted) return;
        if (kDebugMode) print(">>> CONTRASEÑA CAMBIADA, cerrando sesión...");
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        throw Exception(response?['error'] ?? 'Error al cambiar la contraseña');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Nueva contraseña', style: headerStyle),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: _nuevaPasswordController,
                label: 'Nueva contraseña',
                visible: _verNueva,
                onToggle: () => setState(() => _verNueva = !_verNueva),
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: _confirmPasswordController,
                label: 'Confirmar contraseña',
                visible: _verConfirm,
                onToggle: () => setState(() => _verConfirm = !_verConfirm),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obligatorio';
                  }
                  if (value != _nuevaPasswordController.text) {
                    _mostrarErrorCoincidencia = true;
                    return 'Las contraseñas no coinciden';
                  }
                  _mostrarErrorCoincidencia = false;
                  return null;
                },
              ),
              if (_mostrarErrorCoincidencia)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    '❌ Las contraseñas no coinciden',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: elevatedButtonStyle,
                  onPressed: _loading ? null : _cambiarPassword,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Guardar nueva contraseña',
                          style: buttonTextStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool visible,
    required VoidCallback onToggle,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !visible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggle,
        ),
        border: const OutlineInputBorder(),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) return 'Campo obligatorio';
            if (value.length < 6) return 'Debe tener al menos 6 caracteres';
            return null;
          },
    );
  }
}
