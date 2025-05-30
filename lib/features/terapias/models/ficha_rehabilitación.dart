// ==========================================================================
// Modelo de datos para la ficha de rehabilitación
// ==========================================================================

class FichaRehabilitacion {
  final String id; //Identificador único para enlazar con la terapia
  final String titulo; // Título de la ficha de rehabilitación
  final String objetivo; // Objetivo de la terapia
  final String indicacion; // Casos en los que se recomienda la terapia
  final String descripcionTerapia;
  final String comoSeRealiza;
  final String
  observacionesProfesionales; // Observaciones de los profesionales sobre la terapia
  final String observacionesTecnica; // Observaciones técnicas sobre la terapia
  final String saberMas;
  final String videoUrl;
  final List<String> quienesLaRealizan; // Profesionales que realizan la terapia
  final List<String> areasIntervencion; // Áreas de intervención de la terapia

  // Constructor de la clase
  FichaRehabilitacion({
    required this.id,
    required this.titulo,
    required this.objetivo,
    required this.indicacion,
    required this.descripcionTerapia,
    required this.observacionesProfesionales,
    required this.observacionesTecnica,
    required this.comoSeRealiza,
    required this.saberMas,
    required this.videoUrl,
    required this.quienesLaRealizan,
    required this.areasIntervencion,
  });

  // Método factory para crear una instancia de FichaRehabilitacion desde un JSON
  factory FichaRehabilitacion.fromJson(Map<String, dynamic> json) {
    return FichaRehabilitacion(
      id: json['id'] ?? '',
      titulo: json['titulo'] ?? '',
      objetivo: json['objetivo'] ?? '',
      indicacion: json['indicacion'] ?? '',
      descripcionTerapia: json['descripcion'] ?? '',
      // Manejar el campo comoSeRealiza que puede ser lista o string
      comoSeRealiza:
          json['comoSeRealiza'] is List
              ? (json['comoSeRealiza'] as List).join(
                '\n',
              ) // Convierte lista a string
              : json['comoSeRealiza']?.toString() ?? '',
      observacionesProfesionales: json['observacionesProfesionales'] ?? '',
      observacionesTecnica: json['observacionesTecnica'] ?? '',
      saberMas: json['saberMas'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      quienesLaRealizan:
          json['quienesLaRealizan'] != null
              ? List<String>.from(
                json['quienesLaRealizan'],
              ) // Convierte a lista de strings
              : [],
      areasIntervencion:
          json['areasIntervencion'] != null
              ? List<String>.from(json['areasIntervencion'])
              : [],
    );
  }

  // Método para convertir la instancia a un JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'objetivo': objetivo,
      'indicacion': indicacion,
      'descripcion': descripcionTerapia,
      'comoSeRealiza': comoSeRealiza,
      'observacionesProfesionales': observacionesProfesionales,
      'observacionesTecnica': observacionesTecnica,
      'saberMas': saberMas,
      'videoUrl': videoUrl,
      'quienesLaRealizan': quienesLaRealizan,
      'areasIntervencion': areasIntervencion,
    };
  }
}
