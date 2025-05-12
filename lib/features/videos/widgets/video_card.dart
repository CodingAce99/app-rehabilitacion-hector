import 'package:app_rehab/features/videos/screens/VideoPlayerScreen.dart';
import 'package:flutter/material.dart';

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

    if (videoId == null) return const SizedBox();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerScreen(videoId: videoId, titulo: titulo),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Miniatura de Youtube
            Image.network(
              'https://img.youtube.com/vi/$videoId/0.jpg',
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                titulo,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
