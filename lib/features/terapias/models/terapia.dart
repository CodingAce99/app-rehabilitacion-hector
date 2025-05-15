class Terapia {
  final String titulo; // Título principal
  final String descripcionCorta; // Texto largo explicativo
  final String descripcionLarga; // Texto corto explicativo
  final String assetImage; // Ruta al asset local (imagen PNG o SVG)
  final List<String> objetivos; // Lista de objetivos terapéuticos
  final List<String> beneficios; // Lista de beneficios o resultados

  Terapia({
    required this.titulo,
    required this.descripcionCorta,
    required this.descripcionLarga,
    required this.assetImage,
    required this.objetivos,
    required this.beneficios,
  });
}
