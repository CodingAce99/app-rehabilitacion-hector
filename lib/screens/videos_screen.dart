import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'VideoPlayerScreen.dart';

// Pantalla principal que muestra los videos por categoría
class VideosScreen extends StatefulWidget {
  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  String filtro = '';

  /// Mapa que agrupa los videos por categoría (clave: nombre de la categoría)
  /// Cada categoría contiene una lista de mapas con título y URL de YouTube
  final Map<String, List<Map<String, String>>> videosPorCategoria = {
    'Fisioterapia': [
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
    ],
    'Logopedia': [
      {
        'titulo': 'Ejercicios de Lenguaje: Automatismos',
        'url': 'https://www.youtube.com/watch?v=w0hFSJqIsBg',
      },
    ],
    'Ortopedia': [
      {
        'titulo': 'Colocación dafo varo ',
        'url': 'https://www.youtube.com/watch?v=FEvXTGSb3is',
      },
    ],
    'Terapia Ocupacional': [
      {
        'titulo': 'Apraxia alimentación',
        'url': 'https://www.youtube.com/watch?v=zzAJCuMhft8',
      },
    ],
    // Añadir mas categorias
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Videos Educativos')),

      // Columna principal: buscador + lista de videos
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar video...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (texto) {
                // Actualiza el filtro cada vez que se escribe algo
                setState(() {
                  filtro = texto.toLowerCase();
                });
              },
            ),
          ),

          // Lista expandible con las categoría y sus videos
          Expanded(
            child: ListView(
              children:
                  videosPorCategoria.entries.map((entry) {
                    final categoria = entry.key;
                    final videos =
                        entry.value
                            .where(
                              (video) => video['titulo']!
                                  .toLowerCase()
                                  .contains(filtro),
                            )
                            .toList();

                    // Si no hay videos que coincidan con el filtro, no muestra nada
                    if (videos.isEmpty) return SizedBox();

                    // Contruye el widget para una categoría
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título de la categoría
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text(
                            categoria,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Muestra cada video como una tarjeta con miniatura y título
                        ...videos.map((video) {
                          // Extrae el ID del video desde la URL
                          final videoId = YoutubePlayer.convertUrlToId(
                            video['url'] ?? '',
                          );
                          if (videoId == null) return SizedBox();

                          // URL de la miniatura del video
                          final thumbnailUrl =
                              'https://img.youtube.com/vi/$videoId/0.jpg';

                          return GestureDetector(
                            onTap: () {
                              // Al pulsar, navega a la pantalla del reproductor
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
                            },
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Miniatura del video
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      thumbnailUrl,
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      video['titulo']!,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
