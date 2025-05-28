// Clase que representa una entrada en el diario personal del usuario
class EntradaDiario {
  // Identificador único de la entrada (por ejemplo, generado con UUID)
  final String id;

  // Fecha y hora en la que se creó la entrada
  final DateTime fecha;

  // Título de la entrada
  final String titulo;

  // Texto escrito por el usuario en esa entrada
  final String texto;

  // Estado de ánimo del usuario
  final String estadoAnimo;

  // Estado del dolor del usuario (opcional)
  final String dolor;

  // Calidad del sueño del usuario
  final String calidadSueno;

  // Terapia asociada a la entrada
  final String terapia;

  // Etiquetas asociadas a la entrada
  final List<String> etiquetas;

  // Ruta de la imagen asociada a la entrada (opcional)
  final String? imagenPath;

  // Áreas del cuerpo donde el usuario siente dolor
  final List<String> areasDolor;

  // Descripción del dolor
  final String descripcionDolor;

  // Constructor de la clase
  EntradaDiario({
    required this.id,
    required this.fecha,
    required this.titulo,
    required this.texto,
    required this.estadoAnimo,
    required this.dolor,
    required this.calidadSueno,
    required this.terapia,
    required this.etiquetas,
    this.imagenPath,
    required this.areasDolor,
    required this.descripcionDolor,
  });

  // Método que convierte esta entrada a un Map (estructura clave-valor)
  // Esto es útil para guardar la entrada como JSON (por ejemplo, en shared_preferences)
  Map<String, dynamic> toJson() => {
    'id': id,
    'fecha': fecha.toIso8601String(),
    'titulo': titulo,
    'texto': texto,
    'estadoAnimo': estadoAnimo,
    'dolor': dolor,
    'calidadSueno': calidadSueno,
    'terapia': terapia,
    'etiquetas': etiquetas,
    'imagenPath': imagenPath,
    'areasDolor': areasDolor,
    'descripcionDolor': descripcionDolor,
  };

  // Método de fábrica que crea una instancia de EntradaDiario desde un Map (JSON)
  // Esto se usa cuando cargamos los datos guardados del diario
  factory EntradaDiario.fromJson(Map<String, dynamic> json) {
    return EntradaDiario(
      id: json['id'],
      fecha: DateTime.parse(json['fecha']),
      titulo: json['titulo'],
      texto: json['texto'],
      estadoAnimo: json['estadoAnimo'] ?? '😐', // Valor por defecto

      dolor: json['dolor'] ?? 'Ninguno',
      calidadSueno: json['calidadSueno'] ?? 'Normal',
      terapia: json['terapia'] ?? 'Ninguna',
      etiquetas: List<String>.from(json['etiquetas'] ?? []),
      imagenPath: json['imagenPath'],
      areasDolor: List<String>.from(json['areasDolor'] ?? []),
      descripcionDolor: json['descripcionDolor'] ?? '',
    );
  }
}
