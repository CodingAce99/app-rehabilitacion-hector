import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'VideoPlayerScreen.dart';

class VideosScreen extends StatelessWidget {
  final List<Map<String, String>> videos = [
    {
      'titulo': 'Bipedestación en espalderas',
      'url': 'https://www.youtube.com/watch?v=qY24xPXy2HY',
    },
    {
      'titulo': 'Colocación y cuidados del brazo pléjico',
      'url': 'https://www.youtube.com/watch?v=Db_qJjV4HVI',
    },
    {
      'titulo': 'Incentivador respiratorio',
      'url': 'https://www.youtube.com/watch?v=oJWKUiqU1SY',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Videos Terapéuticos')),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          final videoId = YoutubePlayer.convertUrlToId(video['url']!);

          return Card(
            margin: EdgeInsets.all(10),
            elevation: 4,
            child: ListTile(
              leading: Icon(
                Icons.play_circle_fill,
                size: 40,
                color: Colors.red,
              ),
              title: Text(video['titulo']!),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                final videoId = YoutubePlayer.convertUrlToId(
                  video['url'] ?? '',
                );
                if (videoId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => VideoPlayerScreen(
                            videoId: videoId,
                            titulo: video['titulo']!,
                          ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('La URL del video no es válida')),
                  );
                }
                /*
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => VideoPlayerScreen(
                          videoId: videoId!,
                          titulo: video['titulo']!,
                        ),
                    
                  ),
                );*/
              },
            ),
          );
        },
      ),
    );
  }
}
