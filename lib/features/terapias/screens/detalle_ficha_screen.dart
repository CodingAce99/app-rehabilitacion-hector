import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/ficha_rehabilitación.dart';
import '../../videos/screens/video_player_screen.dart';

// Pantalla que muestra el detalle completo de una ficha de rehabilitación
class DetalleFichaScreen extends StatefulWidget {
  // Almacena la información de la ficha de rehabilitación
  final FichaRehabilitacion ficha;

  // Constructor de clase
  const DetalleFichaScreen({super.key, required this.ficha});

  @override
  State<DetalleFichaScreen> createState() => _DetalleFichaScreenState();
}

class _DetalleFichaScreenState extends State<DetalleFichaScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // Método build para construir la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    final ficha = widget.ficha;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Secciones principales de la ficha con su respectivo contenido
                  Text(
                    ficha.titulo,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildCard(
                    titulo: 'Descripcion',
                    contenido: ficha.descripcionTerapia,
                    icono: Icons.description,
                  ),
                  _buildCard(
                    titulo: 'Indicación',
                    contenido: ficha.indicacion,
                    icono: Icons.info,
                  ),

                  _buildCard(
                    titulo: 'Cómo se realiza',
                    contenido: ficha.comoSeRealiza,
                    icono: Icons.help,
                  ),
                  _buildCard(
                    titulo: 'Observaciones técnicas',
                    contenido: ficha.observacionesTecnica,
                    icono: Icons.bookmark,
                  ),
                  _buildCard(
                    titulo: 'Saber más',
                    contenido: ficha.saberMas,
                    icono: Icons.book,
                  ),

                  const SizedBox(height: 20),

                  // Secciñon de profesionales implicados
                  Text(
                    'Profesionales implicados',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Lista de profesionales mostrados como ListTile con ícono
                  ...ficha.quienesLaRealizan.map(
                    (p) => ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.primary,
                        size: 28,
                      ),
                      title: Text(p),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Sección de video explicativo
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(
                              context,
                            ).colorScheme.primary, // Color de fondo
                        foregroundColor:
                            Theme.of(
                              context,
                            ).colorScheme.onPrimary, // Color del texto
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 24.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // Bordes redondeados
                        ),
                        elevation: 2, // Sombra ligera
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => VideoPlayerScreen(
                                  videoId: ficha.videoUrl,
                                  titulo: 'Video explicativo',
                                ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.play_circle_fill,
                            size: 20,
                          ), // Icono de reproducción
                          const SizedBox(
                            width: 8,
                          ), // Espaciado entre el icono y el texto
                          Text(
                            'Ver video explicativo',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// =========================
  /// MÉTODOS PRIVADOS
  /// =========================

  // Método para construir una sección
  Widget _buildCard({
    required titulo,
    required String contenido,
    IconData? icono,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icono != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        icono,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      titulo,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Text(
                contenido,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
