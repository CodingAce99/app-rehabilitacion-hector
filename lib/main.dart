// Importaciones de librerías y paquetes
import 'package:flutter/material.dart'; // Importa los widgets basicos de Flutter
import 'package:provider/provider.dart'; // Importa el paquete Provider para la gestión de estado
import 'package:shared_preferences/shared_preferences.dart'; // permite leer/escribir configuraciones guardadas localmente
import 'core/theme/theme_provider.dart';
import 'core/services/preferences_service.dart'; // Importa el servicio de preferencias para manejar configuraciones persistentes

// Otras importaciones
import 'features/diario/providers/diario_provider.dart';
import 'features/terapias/providers/fichas_provider.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/terapias/providers/terapias_provider.dart';
import 'features/terapias/providers/terapias_seguimiento_provider.dart';
import 'core/theme/theme.dart';
import 'features/user/providers/user_provider.dart';

// Importacion de archivo de pruebas
import 'test/estado_animo_chart_test.dart';

// Punto de entrada de la aplicación
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura que los widgets estén inicializados

  // Usa SharedPreferences para verificar si se ha visto el onboarding
  final seenOnboarding = await PreferencesService.getSeenOnboarding();

  // Carga el usuario al iniciar la app
  final userProvider = UserProvider();
  await userProvider.loadUser();

  runApp(
    MyApp(
      showOnboarding: true, // Muestra el onboarding si no se ha visto
      userProvider: userProvider, // Pasa el UserProvider
    ),
  ); // Inicia la app
}

// Clase principal de la aplicación
class MyApp extends StatelessWidget {
  final bool showOnboarding;
  final UserProvider userProvider;

  const MyApp({
    Key? key,
    required this.showOnboarding,
    required this.userProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Usa la instancia existenete de userProvider
        ChangeNotifierProvider.value(value: userProvider),
        // Otros providers necesarios para la aplicación
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DiarioProvider()),
        ChangeNotifierProvider(create: (_) => TerapiasProvider()),
        ChangeNotifierProvider(create: (_) => TerapiasSeguimientoProvider()),
        Provider<FichasProvider>(
          create: (_) {
            final provider = FichasProvider();
            return provider;
          },
        ),
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
            // ...(Rutas Tests)...
            //home: EstadoAnimoChartTest(),
          );
        },
      ),
    );
  }
}
