import 'package:app_rehab/features/videos/screens/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ==========================================================================
// Widget que representa una tarjeta de video de YouTube
// ==========================================================================

class VideoCard extends StatelessWidget {
  final String videoUrl;
  final String titulo;

  // Constructor que recibe la URL del video y el título
  const VideoCard({super.key, required this.videoUrl, required this.titulo});

  // Método para extraer el ID del video de YouTube desde la URL
  String? _extractYoutubeId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    // Verifica si la URL es de YouTube y extrae el ID
    if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v'];
    }

    // Verifica si la URL es de YouTube con formato corto
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final videoId = _extractYoutubeId(videoUrl);
    // Si no hay videoId, no se renderiza nada
    // Esto evita que la app crashee si no hay videoId
    if (videoId == null || videoId.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerScreen(videoId: videoId, titulo: titulo),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(200, 255, 243, 237),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE3CFC4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  child: Text(
                    titulo,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 119, 141, 139),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
