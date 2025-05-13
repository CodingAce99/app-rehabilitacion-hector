import 'package:app_rehab/features/videos/screens/VideoPlayerScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoCard extends StatelessWidget {
  final String videoUrl;
  final String titulo;

  const VideoCard({Key? key, required this.videoUrl, required this.titulo})
    : super(key: key);

  String? _extractYoutubeId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v'];
    }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Miniatura de Youtube
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  'https://img.youtube.com/vi/$videoId/0.jpg',
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  // Si la imagen no se carga, muestra un contenedor de respaldo
                  // Evita que la app crashee
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: const Color(
                        0xFFE5DCD7,
                      ), // Color pastel suave de fondo
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 48,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  titulo,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 119, 141, 139),
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
