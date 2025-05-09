import 'package:flutter/material.dart';
import 'package:mobile_app/config/constants.dart';

class TomarAsistenciaScreen extends StatelessWidget {
  const TomarAsistenciaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Tomar Asistencia', style: headerStyle),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Text(
            'Pantalla para registrar asistencia de empleados.',
            style: labelStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
