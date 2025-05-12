import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import '../models/ficha_rehabilitación.dart';
import '../../videos/widgets/video_card.dart';
import 'package:app_rehab/features/videos/widgets/video_card.dart';

// Pantalla que muestra el detalle completo de una ficha de rehabilitación
class DetalleFichaScreen extends StatefulWidget {
  // Almacena la información de la ficha de rehabilitación
  final FichaRehabilitacion ficha;

  // Constructor de clase
  const DetalleFichaScreen({Key? key, required this.ficha}) : super(key: key);

  @override
  State<DetalleFichaScreen> createState() => _DetalleFichaScreenState();
}

class _DetalleFichaScreenState extends State<DetalleFichaScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(
      const AssetImage('assets/images/ficha_terapia_background.png'),
      context,
    );
  }

  // Método build para construir la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    final ficha = widget.ficha;
    final theme = Theme.of(context); // Accedemos al tema actual para estilos

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/ficha_terapia_background.png",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey,
                ); // color de fondo de respaldo
              },
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Secciones principales de la ficha con su respectivo contenido
                  Text(
                    ficha.titulo,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 143, 170, 167),
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
                    contenido: ficha.indicaciones,
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
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Lista de profesionales mostrados como ListTile con ícono
                  ...ficha.quienesLaRealizan.map(
                    (p) => ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text(p),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Botón opcional para abrir el video en el navegador
                  if (ficha.videoURL.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: VideoCard(
                        videoUrl: ficha.videoURL,
                        titulo: ficha.titulo,
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

  // Método para construir una sección
  Widget _buildCard({
    required titulo,
    required String contenido,
    IconData? icono,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: Color.fromARGB(255, 225, 230, 224).withOpacity(0.8),
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
                        color: Color.fromARGB(255, 224, 173, 145),
                        size: 20,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      titulo,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 119, 141, 139),
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
