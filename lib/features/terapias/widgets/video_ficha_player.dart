import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoFichaPlayer extends StatelessWidget {
  final String videoUrl;

  const VideoFichaPlayer({Key? key, required this.videoUrl}) : super(key: key);

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

    if (videoId == null) {
      return Text('Video no disponible');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
          ),
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: Icon(Icons.open_in_new),
          label: Text('Ver en el navegador'),
          onPressed: () async {
            final url = Uri.parse(videoUrl);
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No se pudo abrir el video')),
              );
            }
          },
        ),
      ],
    );
  }
}
