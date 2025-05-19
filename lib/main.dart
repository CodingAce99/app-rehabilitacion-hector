// Importaciones de librerías y paquetes
import 'package:flutter/material.dart'; // Importa los widgets basicos de Flutter
import 'package:provider/provider.dart'; // Necesario para usar el patrón Provider
import 'package:shared_preferences/shared_preferences.dart'; // permite leer/escribir configuraciones guardadas localmente
import 'core/theme/theme_provider.dart'; // Importa el proveedor de tema

// Importaciones de otras pantallas y widgets
import 'features/diario/providers/diario_provider.dart';
import 'features/terapias/providers/fichas_provider.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/terapias/providers/terapias_provider.dart';
import 'core/theme/theme.dart';

// Punto de entrada de la aplicación
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura que los widgets estén inicializados
  final SharedPreferences prefs =
      await SharedPreferences.getInstance(); // Inicializa SharedPreferences
  final seenOnboarding =
      prefs.getBool('seenOnboarding') ??
      false; // Verifica si el onboarding fue completado

  runApp(MyApp(showOnboarding: !seenOnboarding)); // Inicia la app
}

// Clase principal de la aplicación
class MyApp extends StatelessWidget {
  final bool showOnboarding; // Bandera para mostrar el onboarding

  const MyApp({Key? key, required this.showOnboarding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ...(Aquí se definen los providers)...
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DiarioProvider()),
        ChangeNotifierProvider(create: (_) => TerapiasProvider()),
        Provider<FichasProvider>(create: (_) => FichasProvider()),
      ],
      child: Builder(
        // Builder que permite crear un contexto hijo del MultiProvider
        builder: (context) {
          final themeProvider = Provider.of<ThemeProvider>(
            context,
          ); // Accede al provider del tema
          return MaterialApp(
            // ...(Aquí se define el tema y el titulo de la app)...
            title: 'App Rehabilitación',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,

            // MaterialApp escucha los cambios en el tema
            themeMode: themeProvider.themeMode,

            // ...(Aquí se define la ruta inicial de la app)...
            home:
                showOnboarding
                    ? OnboardingScreen() // Pantalla de onboarding si no se ha visto
                    : DashboardScreen(), // Pantalla principal si ya se vio el onboarding
          );
        },
      ),
    );
  }
}
