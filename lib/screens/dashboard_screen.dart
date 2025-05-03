import 'package:app_rehab/screens/estadisticas_screen.dart';
import 'package:flutter/material.dart';
import 'terapias_screen.dart';
import 'diario_screen.dart';
import 'videos_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  // Función para construir cada opción de la lista
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
        leading: Icon(icon, size: 30, color: Theme.of(context).primaryColor),
        title: Text(
          titulo,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bienvenido')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, Héctor 👋',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '¿Qué deseas hacer hoy?',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 24),

            // Opciones del dashboard
            _buildOption(
              context: context,
              icon: Icons.medical_services_outlined,
              titulo: 'Mis Terapias',
              onTap: () {
                // Navegar a Mis Terapias
                Navigator.of(context).push(_crearRuta(TerapiasScreen()));
              },
            ),
            _buildOption(
              context: context,
              icon: Icons.edit_note_outlined,
              titulo: 'Diario Personal',
              onTap: () {
                // Navegar al Diario
                Navigator.of(context).push(_crearRuta(DiarioScreen()));
              },
            ),
            _buildOption(
              context: context,
              icon: Icons.video_library_outlined,
              titulo: 'Recursos Multimedia',
              onTap: () {
                // Navegar a Recursos
                Navigator.of(context).push(_crearRuta(VideosScreen()));
              },
            ),
            _buildOption(
              context: context,
              icon: Icons.bar_chart_outlined,
              titulo: 'Estadísticas',
              onTap: () {
                // Navegar a Estadísticas
                Navigator.of(context).push(_crearRuta(EstadisticasScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

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
