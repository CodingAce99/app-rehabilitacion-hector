import 'package:flutter/material.dart'; // Para poder usar Material Design
import 'screens/welcome_screen.dart'; // Para poder usar la pantalla de bienvenida
import 'providers/diario_provider.dart'; // Para poder usar el provider del diario
import 'package:provider/provider.dart'; // Para poder usar el provider
import 'screens/diario_screen.dart'; // Para poder usar la pantalla del diario

// Punto de entrada de la aplicación
void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => DiarioProvider())],
      child: MyApp(),
    ),
  );
}

/*
  AppRehab es la aplicación principal

  MaterialApp es el contenedor base para toda la app Flutter,
  con su configuración de navegación, tema y título
*/
class MyApp extends StatelessWidget {
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
