import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'features/diario/providers/diario_provider.dart';
import 'package:provider/provider.dart';
import 'features/diario/screens/diario_screen.dart';
import 'screens/dashboard_screen.dart';

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
      home: DashboardScreen(), // Muestra la pantalla de Dashboard al inicio
    );
  }
}
