// Clase que representa un modelo de Terapia en la aplicación.
class Terapia {
  final String titulo; // Título principal
  final String descripcionCorta; // Texto largo explicativo
  final String descripcionLarga; // Texto corto explicativo
  final String assetImage; // Ruta al asset local (imagen PNG o SVG)
  final List<String> objetivos; // Lista de objetivos terapéuticos
  final List<String> beneficios; // Lista de beneficios o resultados
  final bool completada; // Estado de la terapia (completada o no)

  // Constructor de la clase Terapia
  Terapia({
    required this.titulo,
    required this.descripcionCorta,
    required this.descripcionLarga,
    required this.assetImage,
    required this.objetivos,
    required this.beneficios,
    this.completada = false,
  });

  // factory para crear una instancia de Terapia a partir de un mapa JSON
  factory Terapia.fromJson(Map<String, dynamic> json) {
    return Terapia(
      titulo: json['titulo'] as String,
      descripcionCorta: json['descripcionCorta'] as String,
      descripcionLarga: json['descripcionLarga'] as String,
      assetImage: json['assetImage'] as String,
      objetivos: List<String>.from(json['objetivos']),
      beneficios: List<String>.from(json['beneficios']),
    );
  }

  // Método para convertir una instancia de Terapia a un mapa JSON
  Map<String, dynamic> toJson() => {
    'titulo': titulo,
    'descripcionCorta': descripcionCorta,
    'descripcionLarga': descripcionLarga,
    'assetImage': assetImage,
    'objetivos': objetivos,
    'beneficios': beneficios,
  };
}
