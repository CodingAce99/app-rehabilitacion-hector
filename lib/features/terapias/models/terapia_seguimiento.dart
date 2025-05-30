// Importaciones de otras pantallas y widgets
import '../models/ficha_rehabilitación.dart';

// ==========================================================================
// Modelo de datos para el seguimiento de una terapia
// ==========================================================================

class TerapiaSeguimiento {
  final String id; // Id único para esta instancia de seguimiento
  final String nombre; // Nombre de la terapia
  final FichaRehabilitacion ficha;
  bool completada;
  final DateTime fechaInicio;
  DateTime? fechaFin;
  String? notas;

  // Constructor de la clase
  TerapiaSeguimiento({
    required this.id,
    required this.nombre,
    required this.ficha,
    this.completada = false,
    required this.fechaInicio,
    this.fechaFin,
    this.notas,
  });

  // Serialización para almacenamiento local (SharedPreferences)
  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'ficha': ficha.toJson(), // Serializa la ficha asociada
    'completada': completada,
    'fechaInicio': fechaInicio.toIso8601String(), // Fecha en formato ISO 8601
    'fechaFin': fechaFin?.toIso8601String(),
    'notas': notas,
  };

  // Deserialización desde almacenamiento local (SharedPreferences)
  factory TerapiaSeguimiento.fromJson(Map<String, dynamic> json) =>
      TerapiaSeguimiento(
        id: json['id'],
        nombre: json['nombre'],
        ficha: FichaRehabilitacion.fromJson(json['ficha']),
        completada: json['completada'],
        fechaInicio: DateTime.parse(json['fechaInicio']),
        fechaFin:
            json['fechaFin'] != null
                ? DateTime.parse(json['fechaFin'])
                : null, // Maneja el caso donde fechaFin puede ser nulo
        notas: json['notas'],
      );
}
