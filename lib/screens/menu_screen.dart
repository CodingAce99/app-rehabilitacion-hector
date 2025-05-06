import 'package:flutter/material.dart'; // Importamos Material Design para usar sus widgets
import '../features/terapias/screens/terapias_screen.dart'; // Importamos la pantalla de terapias
import '../features/videos/screens/videos_screen.dart'; // Importamos la pantalla de videos
import '../features/diario/screens/diario_screen.dart'; // Importamos la pantalla de diario
import 'estadisticas_screen.dart'; // Importamos la pantalla de estadísticas

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menú Principal')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        // GridView para colocar las tarjetas en forma de cuadrícula
        child: GridView.count(
          crossAxisCount: 2, // columnas
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            // Cada tarjeta es creada con _buildMenuItem. Aquí se definen los iconos y títulos
            _buildMenuItem(context, Icons.local_hospital, 'Terapias'),
            _buildMenuItem(context, Icons.play_circle_fill, 'Videos'),
            _buildMenuItem(context, Icons.book, 'Diario'),
            _buildMenuItem(context, Icons.bar_chart, 'Estadísticas'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title) {
    // GestureDetector para detectar pulsaciones en la tarjeta
    return GestureDetector(
      onTap: () {
        if (title == 'Terapias') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TerapiasScreen()),
          );
        } else if (title == 'Videos') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => VideosScreen()),
          );
        } else if (title == 'Diario') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DiarioScreen()),
          );
        } else if (title == 'Estadísticas') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EstadisticasScreen()),
          );
        }
      },
      // Cada Card tiene un icono y un título, centrados en columna
      child: Card(
        elevation: 4, // Sombra para que parezca una tarjeta flotante
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
