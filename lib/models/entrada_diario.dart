// Clase que representa una entrada en el diario personal del usuario
class EntradaDiario {
  // Identificador único de la entrada (por ejemplo, generado con UUID)
  final String id;

  // Fecha y hora en la que se creó la entrada
  final DateTime fecha;

  // Texto escrito por el usuario en esa entrada
  final String texto;

  // Estado de ánimo del usuario
  final String estadoAnimo;

  // Etiquetas asociadas a la entrada
  final List<String> etiquetas;

  // Ruta de la imagen asociada a la entrada (opcional)
  final String? imagenPath;

  // Constructor de la clase
  EntradaDiario({
    required this.id,
    required this.fecha,
    required this.texto,
    required this.estadoAnimo,
    required this.etiquetas,
    this.imagenPath,
  });

  // Método que convierte esta entrada a un Map (estructura clave-valor)
  // Esto es útil para guardar la entrada como JSON (por ejemplo, en shared_preferences)
  Map<String, dynamic> toJson() => {
    'id': id,
    'fecha': fecha.toIso8601String(),
    'texto': texto,
    'estadoAnimo': estadoAnimo,
    'etiquetas': etiquetas,
    'imagenPath': imagenPath,
  };

  // Método de fábrica que crea una instancia de EntradaDiario desde un Map (JSON)
  // Esto se usa cuando cargamos los datos guardados del diario
  factory EntradaDiario.fromJson(Map<String, dynamic> json) {
    return EntradaDiario(
      id: json['id'],
      fecha: DateTime.parse(json['fecha']),
      texto: json['texto'],
      estadoAnimo:
          json['estadoAnimo'] ?? '😐', // Valor por defecto si es antiguo
      etiquetas: List<String>.from(json['etiquetas'] ?? []),
      imagenPath: json['imagenPath'], // Recuperamos la lista
    );
  }
}
