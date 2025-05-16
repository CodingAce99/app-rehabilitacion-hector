import 'package:app_rehab/features/dashboard/widgets/ultima_entrada_card.dart';
import 'package:app_rehab/features/estadisticas/estadisticas_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../terapias/screens/terapias_screen.dart';
import '../../diario/screens/diario_screen.dart';
import '../../diario/screens/detalle_entrada_screen.dart';
import '../../diario/providers/diario_provider.dart';
import '../../../screens/settings_screen.dart';
import '../widgets/acceso_rapido_card.dart';
import '../widgets/resumen_estado_animo_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final diarioProvider = Provider.of<DiarioProvider>(context);
    final ultimaEntrada =
        diarioProvider.entradas.isNotEmpty
            ? diarioProvider.entradas.last
            : null;

    return Scaffold(
      appBar: AppBar(title: Text('Resumen Diario')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Encabezado con Saludo
            _buildSaludo(context),
            const SizedBox(height: 16),

            /// =================================
            /// 2. Gráfico Resumen Estado Animico
            /// =================================
            SizedBox(
              height: 260, // altura fija para gráfico + leyenda
              child: EstadoAnimoBarChart(
                resumenEstados: {
                  'Feliz': 5,
                  'Triste': 2,
                  'Enojado': 1,
                  'Ansioso': 3,
                  'Neutral': 4,
                },
                estadoColores: {
                  'Feliz': Colors.green, // Éxito / bienestar
                  'Triste': Colors.blue, // Tranquilidad / tristeza
                  'Enojado': Colors.red, // Alerta / ira
                  'Ansioso': Colors.orange, // Energía / ansiedad
                  'Neutral': Colors.grey, // Estado neutro
                },
              ),
            ),
            const SizedBox(height: 16),

            /// =============================
            /// 3. Última entrada del Diario
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
                          (_) => DetalleEntradaScreen(entrada: ultimaEntrada),
                    ),
                  );
                },
              ),
            ],
            SizedBox(height: 16),

            /// ==================================
            /// 4. Acceso rápido a otras secciones
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
                  () =>
                      Navigator.of(context).push(_crearRuta(TerapiasScreen())),
            ),
            AccesoRapidoCard(
              icon: Icons.edit_note_outlined,
              titulo: 'Diario Personal',
              onTap:
                  () => Navigator.of(context).push(_crearRuta(DiarioScreen())),
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
                  () =>
                      Navigator.of(context).push(_crearRuta(SettingsScreen())),
            ),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// MÉTODOS PRIVADOS
  /// =========================

  // Saludo inicial
  Widget _buildSaludo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¡Hola, [Nombre]! 👋',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          'Este es tu resumen del dia:',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  // Construye cada opción de la lista
  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String titulo,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Theme.of(context).iconTheme.color),
        title: Text(titulo, style: Theme.of(context).textTheme.bodyLarge),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Theme.of(context).iconTheme.color,
        ),
        onTap: onTap,
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
