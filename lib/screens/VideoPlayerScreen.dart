import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// Pantalla que muestra un video de YouTube con su título
class VideoPlayerScreen extends StatefulWidget {
  final String videoId;
  final String titulo;

  // Constructor de la pantalla
  const VideoPlayerScreen({
    super.key,
    required this.videoId,
    required this.titulo,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  // Se llama al crear el widget
  @override
  void initState() {
    super.initState();

    // Inicializa el controlador del reproductor de YouTube
    _controller = YoutubePlayerController(
      initialVideoId:
          widget.videoId, // ID del video recibido desde la pantalla anterior
      flags: YoutubePlayerFlags(
        autoPlay: true, // Reproduce automáticamente al entrar
        mute: false, // No está en silencio por defecto
      ),
    );
  }

  // Se llama cuando el widget se destruye (para liberar recursos)
  @override
  void dispose() {
    _controller.dispose(); // Libera el controlador del video
    super.dispose();
  }

  // Construcción de la interfaz
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      // Este widget separa el reproductor del resto de la UI
      player: YoutubePlayer(controller: _controller),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.titulo),
          ), // Muestra el título en la AppBar
          body: Column(
            children: [
              player, // Aquí se muestra el reproductor de video
              SizedBox(height: 20),

              // Texto informativo debajo del reproductor
              Text(
                'Reproduciendo: ${widget.titulo}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        );
      },
    );
  }
}
