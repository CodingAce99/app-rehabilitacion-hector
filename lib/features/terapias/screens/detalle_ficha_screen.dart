import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/ficha_rehabilitación.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/video_ficha_player.dart';

// Pantalla que muestra el detalle completo de una ficha de rehabilitación
class DetalleFichaScreen extends StatelessWidget {
  // Almacena la información de la ficha de rehabilitación
  final FichaRehabilitacion ficha;

  // Constructor de clase
  const DetalleFichaScreen({Key? key, required this.ficha}) : super(key: key);

  // Método build para construir la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Accedemos al tema actual para estilos

    return Scaffold(
      appBar: AppBar(title: Text(ficha.titulo)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Secciones principales de la ficha con su respectivo contenido
            _buildCard(
              titulo: 'Descripcion',
              contenido: ficha.descripcionTerapia,
            ),
            _buildCard(titulo: 'Indicación', contenido: ficha.indicaciones),

            _buildCard(
              titulo: 'Cómo se realiza',
              contenido: ficha.comoSeRealiza,
            ),
            _buildCard(
              titulo: 'Observaciones técnicas',
              contenido: ficha.observacionesTecnica,
            ),
            _buildCard(titulo: 'Saber más', contenido: ficha.saberMas),

            const SizedBox(height: 20),

            // Secciñon de profesionales implicados
            Text(
              'Profesionales implicados',
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Lista de profesionales mostrados como ListTile con ícono
            ...ficha.quienesLaRealizan.map(
              (p) =>
                  ListTile(leading: Icon(Icons.person_outline), title: Text(p)),
            ),

            const SizedBox(height: 30),

            // Botón opcional para abrir el video en el navegador
            if (ficha.videoURL.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: VideoFichaPlayer(videoUrl: ficha.videoURL),
              ),
          ],
        ),
      ),
    );
  }

  // Método para construir una sección
  Widget _buildCard({required titulo, required String contenido}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              contenido,
              style: TextStyle(fontSize: 15, color: Colors.grey[800]),
            ),
          ],
        ),
      ),
    );
  }
}
