// Importaciones de librerías y paquetes
import 'package:app_rehab/features/dashboard/widgets/resumen_progreso_card.dart';
import 'package:app_rehab/features/dashboard/widgets/ultima_entrada_card.dart';
import 'package:app_rehab/features/estadisticas/estadisticas_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importaciones de otras pantallas y widgets
import '../../terapias/screens/terapias_screen.dart';
import '../../diario/screens/diario_screen.dart';
import '../../diario/screens/detalle_entrada_screen.dart';
import '../../diario/providers/diario_provider.dart';
import '../../../screens/settings_screen.dart';
import '../widgets/acceso_rapido_card.dart';
import '../widgets/resumen_estado_animo_chart.dart';
import '../../terapias/providers/terapias_seguimiento_provider.dart';
import '../../terapias/screens/seguimiento_terapias_screen.dart';
import '../../user/providers/user_provider.dart';
import '../../../core/services/reminder_service.dart';
import '../../settings/widgets/custom_notification.dart';

// Clase que representa la patalla principal (Dashboard) de la aplicación
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    // Verficar recordatorios al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verificarRecordatorios();
    });
  }

  // Verifica si hay recordatorios pendientes y los muestra
  Future<void> _verificarRecordatorios() async {
    final reminderService = ReminderService.instance;

    // Verificar si es hora de terapia
    if (await reminderService.esHoraDeMostrarRecordatorio('terapias')) {
      if (mounted) {
        CustomNotification.mostrar(
          context,
          titulo: 'Recordatorio de terapia',
          mensaje: 'Es hora de realizar tus ejercicios de rehabilitación',
        );
      }
    }

    // Verificar si es hora del diario
    if (await reminderService.esHoraDeMostrarRecordatorio('diario')) {
      if (mounted) {
        CustomNotification.mostrar(
          context,
          titulo: 'Recordatorio de diario',
          mensaje:
              '¿Cómo te sientes hoy? Es momento de registrar tu estado de ánimo',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final diarioProvider = Provider.of<DiarioProvider>(context);
    final seguimientoProvider = Provider.of<TerapiasSeguimientoProvider>(
      context,
    );
    final isLoading = diarioProvider.isLoading;
    final entradas = diarioProvider.entradas;
    final ultimaEntrada = entradas.isNotEmpty ? entradas.first : null;
    final cantidadEntradas = diarioProvider.entradas.length;
    final completadas = seguimientoProvider.contarCompletadas();

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/backgrounds/ficha_terapia_background.png',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Resumen Diario'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// =========================
                        // 1. Encabezado con Saludo
                        /// =========================
                        _buildSaludo(context),
                        const SizedBox(height: 16),

                        /// ===========================
                        /// 2. Resumen de Progreso General
                        /// ===========================
                        if (cantidadEntradas > 0) ...[
                          Text(
                            'Tu progreso:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          ResumenProgresoCard(
                            texto:
                                'Has registrado $cantidadEntradas entradas en tu diario.',
                          ),
                        ],
                        if (completadas > 0) ...[
                          ResumenProgresoCard(
                            texto: 'Has completado $completadas terapias.',
                          ),
                        ],
                        const SizedBox(height: 16),

                        /// =================================
                        /// 3. Gráfico Resumen Estado Animico
                        /// =================================
                        Text(
                          'Estado de ánimo reciente:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 260, // altura fija para gráfico + leyenda
                          child: EstadoAnimoLineChart(
                            /// Obtiene la distribución de estados de ánimo de los últimos 7 días
                            resumenEstados: diarioProvider
                                .obtenerDistribucionEstadosAnimoFiltrados(
                                  dias: 7,
                                ),
                            estadoColores: {
                              'Feliz': const Color(0xFFA8D5BA),
                              'Triste': const Color(0xFFB5CFE1),
                              'Enojado': const Color(0xFFF6B6A8),
                              'Ansioso': const Color(0xFFF7D8AE),
                              'Neutral': const Color(0xFFDCDCDC),
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// =============================
                        /// 4. Última entrada del Diario
                        /// =============================
                        if (ultimaEntrada != null) ...[
                          Text(
                            'Última entrada registrada:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          UltimaEntradaCard(
                            entrada: ultimaEntrada,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => DetalleEntradaScreen(
                                        entrada: ultimaEntrada,
                                      ),
                                ),
                              );
                            },
                          ),
                        ],
                        SizedBox(height: 16),

                        /// ==================================
                        /// 5. Acceso rápido a otras secciones
                        /// ==================================
                        Text(
                          'Acceso rápido:',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),

                        AccesoRapidoCard(
                          icon: Icons.medical_services_outlined,
                          titulo: 'Mis Terapias',
                          onTap:
                              () => Navigator.of(
                                context,
                              ).push(_crearRuta(TerapiasScreen())),
                        ),
                        AccesoRapidoCard(
                          icon: Icons.edit_note_outlined,
                          titulo: 'Diario Personal',
                          onTap:
                              () => Navigator.of(
                                context,
                              ).push(_crearRuta(DiarioScreen())),
                        ),
                        AccesoRapidoCard(
                          icon: Icons.track_changes_outlined,
                          titulo: 'Seguimiento Terapias',
                          onTap:
                              () => Navigator.of(
                                context,
                              ).push(_crearRuta(SeguimientoTerapiasScreen())),
                        ),
                        // acceso a estadisticas
                        AccesoRapidoCard(
                          icon: Icons.videocam_outlined,
                          titulo: 'Estadísticas',
                          onTap:
                              () => Navigator.of(
                                context,
                              ).push(_crearRuta(EstadisticasScreen())),
                        ),
                        AccesoRapidoCard(
                          icon: Icons.settings_outlined,
                          titulo: 'Configuración',
                          onTap:
                              () => Navigator.of(
                                context,
                              ).push(_crearRuta(SettingsScreen())),
                        ),
                        const SizedBox(height: 16),

                        // Botón flotante para probar recordatorio
                        FloatingActionButton(
                          onPressed: () {
                            // Mostrar recordatorio de prueba
                            CustomNotification.mostrar(
                              context,
                              titulo: 'Recordatorio de prueba',
                              mensaje:
                                  'Este es un recordatorio de prueba manual',
                            );
                          },
                          tooltip: 'Probar recordatorio',
                          child: const Icon(Icons.notification_add),
                        ),
                      ],
                    ),
                  ),
        ),
      ],
    );
  }

  /// =========================
  /// MÉTODOS PRIVADOS
  /// =========================

  // Saludo inicial
  Widget _buildSaludo(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final nombre = userProvider.user?.nombre ?? 'Usuario';

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '¡Hola, $nombre! 👋🏻',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            'Este es tu resumen del dia:',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  // Crea una ruta personalizada con una animación de deslizamiento
  Route _crearRuta(Widget destino) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destino,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Inicia desde la derecha
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: Duration(milliseconds: 400), // Un poquito más rápido
    );
  }
}
