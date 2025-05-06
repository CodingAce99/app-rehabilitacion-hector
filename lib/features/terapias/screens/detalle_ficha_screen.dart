import 'package:flutter/material.dart';
import '../models/ficha_rehabilitación.dart';

class DetalleFichaScreen extends StatelessWidget {
  // Almacena la información de la ficha de rehabilitación
  final FichaRehabilitacion ficha;

  // Constructor de clase
  const DetalleFichaScreen({Key? key, required this.ficha}) : super(key: key);

  // Método build para construir la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ficha.titulo)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Aquí van las secciones de la ficha
            _buildSeccion(
              titulo: 'Descripcion',
              contenido: ficha.descripcionTerapia,
            ),
            _buildSeccion(titulo: 'Indicación', contenido: ficha.indicaciones),

            _buildSeccion(
              titulo: 'Cómo se realiza',
              contenido: ficha.comoSeRealiza,
            ),
            _buildSeccion(
              titulo: 'Observaciones técnicas',
              contenido: ficha.observacionesTecnica,
            ),
            _buildSeccion(titulo: 'Saber más', contenido: ficha.saberMas),
            const SizedBox(height: 20),
            Text(
              'Profesionales implicados',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ...ficha.profesionales.map(
              (p) =>
                  ListTile(leading: Icon(Icons.person_outline), title: Text(p)),
            ),
            const SizedBox(height: 20),
            // Si hay un videoURL, mostramos un botón para abrirlo
            if (ficha.videoURL != null)
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.play_circle_outline),
                  label: Text('Ver video'),
                  onPressed: () {
                    // Aquí se puede implementar la lógica para abrir el video
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Método para construir una sección
  Widget _buildSeccion({required String titulo, required String contenido}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text(
            contenido,
            style: TextStyle(fontSize: 15, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
