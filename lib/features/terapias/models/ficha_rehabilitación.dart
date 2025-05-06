class FichaRehabilitacion {
  final String titulo; // Título principal
  final String descripcionTerapia; // Explicaciónn general de la terapia
  final String indicaciones; // Casos en los que se recomienda la terapia
  final String comoSeRealiza; // Procedimiento o pasos para realizar la terapia
  final String observacionesTecnica; // Recomendaciones técnicas adicionales
  final String saberMas; // Información extra o consejos
  final List<String> profesionales; // Lista de profesionales
  final String? videoURL; // para el QR o enlace

  FichaRehabilitacion({
    required this.titulo,
    required this.descripcionTerapia,
    required this.indicaciones,
    required this.comoSeRealiza,
    required this.observacionesTecnica,
    required this.saberMas,
    required this.profesionales,
    this.videoURL,
  });
}
