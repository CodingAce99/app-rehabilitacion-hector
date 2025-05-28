class FichaRehabilitacion {
  final String id; // para enlazar con la terapia
  final String titulo;
  final String objetivo;
  final String indicacion; // Casos en los que se recomienda la terapia
  final String descripcionTerapia;
  final String comoSeRealiza;
  final String observacionesProfesionales;
  final String observacionesTecnica;
  final String saberMas;
  final String videoUrl;
  final List<String> quienesLaRealizan;
  final List<String> areasIntervencion;

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
              ? (json['comoSeRealiza'] as List).join('\n')
              : json['comoSeRealiza']?.toString() ?? '',
      observacionesProfesionales: json['observacionesProfesionales'] ?? '',
      observacionesTecnica: json['observacionesTecnica'] ?? '',
      saberMas: json['saberMas'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      quienesLaRealizan:
          json['quienesLaRealizan'] != null
              ? List<String>.from(json['quienesLaRealizan'])
              : [],
      areasIntervencion:
          json['areasIntervencion'] != null
              ? List<String>.from(json['areasIntervencion'])
              : [],
    );
  }

  // Define un metodo toJson para convertir el objeto a JSON
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
