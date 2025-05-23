import 'package:flutter/material.dart';

// ✅ API BASE URL
const String apiBaseUrl =
    'http://10.0.2.2:8000/api'; // Para pruebas en emulador android

/* const String apiBaseUrl =
    'http://192.168.152.200:8000/api'; */ // para pruebas en celular

/* const String apiBaseUrl = 'http://3.92.188.9:80/api'; */

// ✅ COLORES PRINCIPALES
const Color primaryColor = Color(0xFF3F51B5); // Azul
const Color accentColor = Color(0xFFFFC107); // Amarillo
const Color backgroundColor = Color(0xFFF5F5F5); // Fondo gris claro
const Color errorColor = Colors.redAccent; // Rojo

// Colores de texto y acento
const Color textColor = Colors.black87;
const Color subtitleColor = Colors.black54;
const Color sectionLabelColor = Colors.grey;
const Color dangerColor = Color(0xFFE57373); // Rojo claro
const Color cardBackgroundColor = Color(0xFFFFFFFF); // blanco puro
const Color cardShadowColor = Color(0x11000000); // sombra suave
const Color avatarColor = Color(0xFF3F51B5); // igual a primary
const Color textLightColor = Colors.black54;
const double cardElevation = 2.0;

// ✅ PADDING Y DISEÑO
const double defaultPadding = 16.0;
const double borderRadius = 12.0;
const double buttonPadding = 14.0;

// ✅ ESTILOS DE TEXTO
const TextStyle headerStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.bold,
  color: Colors.black87,
);

const TextStyle labelStyle = TextStyle(
  fontSize: 16,
  color: Color.fromARGB(136, 0, 0, 0),
);

const TextStyle inputTextStyle = TextStyle(
  fontSize: 16,
);

const TextStyle buttonTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

const TextStyle smallTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.grey,
);

// Estilo botones
final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: primaryColor,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
);
