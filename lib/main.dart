// Importaciones de librerías y paquetes
import 'package:flutter/material.dart'; // Importa los widgets basicos de Flutter
import 'package:provider/provider.dart'; // Importa el paquete Provider para la gestión de estado
import 'dart:async'; // Importa Timer y otras utilidades asíncronas
import 'core/theme/theme_provider.dart';
import 'core/services/preferences_service.dart'; // Importa el servicio de preferencias para manejar configuraciones persistentes
import 'core/services/reminder_service.dart'; // Importa el servicio de recordatorios

// Otras importaciones
import 'features/diario/providers/diario_provider.dart';
import 'features/terapias/providers/fichas_provider.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/terapias/providers/terapias_provider.dart';
import 'features/terapias/providers/terapias_seguimiento_provider.dart';
import 'core/theme/theme.dart';
import 'features/user/providers/user_provider.dart';
import 'features/settings/widgets/custom_notification.dart';

// Clave del navegador global para acceder a la navegación desde cualquier parte de la app
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Timer global para verificar recordatorios
Timer? _reminderTimer;

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
      navigatorKey: navigatorKey, // Pasa la clave de navegación
    ),
  ); // Inicia la app

  // Inicia el temporizador para verificar los recordatorios
  _iniciarVerificacionDeRecordatorios();
}

// Función para verificar periódicamente los recordatorios
void _iniciarVerificacionDeRecordatorios() {
  // Cancelar el temporizador anterior si existe
  _reminderTimer?.cancel();

  // Verificar cada 5 minutos si hay recordatorios para mostrar
  _reminderTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
    // Solo verificamos si hay una pantalla activa
    if (navigatorKey.currentContext != null) {
      final context = navigatorKey.currentContext!;
      final reminderService = ReminderService.instance;

      // Verificar recordatorios de terapia
      if (await reminderService.esHoraDeMostrarRecordatorio('terapias')) {
        CustomNotification.mostrar(
          context,
          titulo: 'Recordatorio de terapia',
          mensaje: 'Es hora de realizar tus ejercicios de rehabilitación',
        );
      }

      // Verificar recordatorios de diario
      if (await reminderService.esHoraDeMostrarRecordatorio('diario')) {
        CustomNotification.mostrar(
          context,
          titulo: 'Recordatorio de diario',
          mensaje:
              '¿Cómo te sientes hoy? Es momento de registrar tu estado de ánimo',
        );
      }
    }
  });
}

// Detener el temporizador
void detenerVerificacionDeRecordatorios() {
  _reminderTimer?.cancel();
  _reminderTimer = null;
}

// Clase principal de la aplicación
class MyApp extends StatelessWidget {
  final bool showOnboarding;
  final UserProvider userProvider;
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({
    Key? key,
    required this.showOnboarding,
    required this.userProvider,
    required this.navigatorKey,
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
            // Usa la clave del navegador para acceder al contexto desde cualquier lugar
            navigatorKey: navigatorKey,

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
