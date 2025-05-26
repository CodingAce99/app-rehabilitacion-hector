// Importaciones de otras pantallas y widgets
import '../models/ficha_rehabilitación.dart';

class TerapiaSeguimiento {
  final String id; // Id único para esta instancia de seguimiento
  final String nombre; // Nombre de la terapia
  final FichaRehabilitacion ficha;
  bool completada;
  final DateTime fechaInicio;
  DateTime? fechaFin;
  String? notas;

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
    'ficha': ficha.toJson(),
    'completada': completada,
    'fechaInicio': fechaInicio.toIso8601String(),
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
            json['fechaFin'] != null ? DateTime.parse(json['fechaFin']) : null,
        notas: json['notas'],
      );
}
