import 'package:flutter/material.dart'; // Para poder usar Material Design
import 'screens/welcome_screen.dart'; // Para poder usar la pantalla de bienvenida

// Punto de entrada de la aplicación
void main() {
  runApp(AppRehab());
}

/*
  AppRehab es la aplicación principal

  MaterialApp es el contenedor base para toda la app Flutter,
  con su configuración de navegación, tema y título
*/
class AppRehab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quita la etiqueta de debug
      title: 'App Rehabilitación',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF9F9FB),
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(), // Muestra la pantalla de bienvenida
    );
  }
}
