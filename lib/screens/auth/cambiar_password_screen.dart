import 'package:flutter/material.dart';
import 'package:mobile_app/config/constants.dart';

class CambiarPasswordScreen extends StatefulWidget {
  const CambiarPasswordScreen({super.key});

  @override
  State<CambiarPasswordScreen> createState() => _CambiarPasswordScreenState();
}

class _CambiarPasswordScreenState extends State<CambiarPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordActualController = TextEditingController();
  final _nuevaPasswordController = TextEditingController();

  bool _loading = false;
  bool _verActual = false;
  bool _verNueva = false;

  void _cambiarPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    // Aquí iría la llamada real a la API
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contraseña actualizada correctamente'),
        backgroundColor: primaryColor,
      ),
    );

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Cambiar Contraseña', style: headerStyle),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordActualController,
                obscureText: !_verActual,
                decoration: InputDecoration(
                  labelText: 'Contraseña actual',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_verActual
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _verActual = !_verActual;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nuevaPasswordController,
                obscureText: !_verNueva,
                decoration: InputDecoration(
                  labelText: 'Nueva contraseña',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_verNueva
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _verNueva = !_verNueva;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.length < 6
                        ? 'Debe tener al menos 6 caracteres'
                        : null,
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
                      : const Text('Guardar cambios', style: buttonTextStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
