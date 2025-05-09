import 'package:flutter/material.dart';
import 'package:mobile_app/config/constants.dart';

class AsistenciasScreen extends StatelessWidget {
  const AsistenciasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Asistencias del Día', style: headerStyle),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Text(
            'Aquí se mostrarán las asistencias registradas hoy.',
            style: labelStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
