class FichaRehabilitacion {
  final String idTerapia; // para enlazar con la terapia
  final String titulo; // Título principal
  final String objetivo; // Objetivo de la terapia
  final String indicaciones; // Casos en los que se recomienda la terapia
  final String descripcionTerapia; // Explicaciónn general de la terapia
  final String comoSeRealiza; // Procedimiento o pasos para realizar la terapia
  final String
  observacionesProfesionales; // Recomendaciones profesionales adicionales
  final String observacionesTecnica; // Observaciones técnicas
  final String saberMas; // Información extra o consejos
  final String videoURL; // URL del video relacionado (opcional)
  final List<String>
  quienesLaRealizan; // Lista de profesionales que la realizan
  final List<String> areasIntervencion; // Áreas de intervención

  FichaRehabilitacion({
    required this.idTerapia,
    required this.titulo,
    required this.objetivo,
    required this.indicaciones,
    required this.descripcionTerapia,
    required this.observacionesProfesionales,
    required this.observacionesTecnica,
    required this.comoSeRealiza,
    required this.saberMas,
    required this.videoURL,
    required this.quienesLaRealizan,
    required this.areasIntervencion,
  });

  factory FichaRehabilitacion.fromJson(Map<String, dynamic> json) {
    return FichaRehabilitacion(
      idTerapia: json['id'],
      titulo: json['titulo'],
      objetivo: json['objetivo'],
      indicaciones: json['indicacion'],
      descripcionTerapia: json['descripcion'],
      comoSeRealiza: json['comoSeRealiza'],
      observacionesProfesionales: json['observacionesProfesionales'],
      observacionesTecnica: json['observacionesTecnica'],
      saberMas: json['saberMas'],
      videoURL: json['videoUrl'],
      quienesLaRealizan: List<String>.from(json['quienesLaRealizan']),
      areasIntervencion: List<String>.from(json['areasIntervencion']),
    );
  }
}
