import 'dart:convert'; // para decodificar el JSON
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // para acceder a rootBundle
import '../models/ficha_rehabilitación.dart';

// Proveedor de datos para las fichas de rehabilitación
class FichasProvider {
  // Mapa privado que almacena las fichas agrupadas por categoría (ej. "Fisioterapia")
  final Map<String, List<FichaRehabilitacion>> _fichasPorCategoria = {};

  // Getter público para acceder a las fichas agrupadas por categoría
  Map<String, List<FichaRehabilitacion>> get fichasPorCategoria =>
      _fichasPorCategoria;

  // Método que carga el JSON desde los assets y lo transforma en objetos Dart
  Future<void> cargarFichasDesdeJson() async {
    // Carga el contenido del archivo JSON como un String
    final String jsonString = await rootBundle.loadString(
      'assets/data/terapias.json',
    );
    // Decodifica el JSON en un Map<String, dynamic>
    final Map<String, dynamic> data = json.decode(jsonString);
    // Itera sobre cada categoría del JSON
    data.forEach((categoria, lista) {
      // Convierte cada elemento de la lista en una instancia de FichaRehabilitacion
      _fichasPorCategoria[categoria] =
          (lista as List)
              .map((item) => FichaRehabilitacion.fromJson(item))
              .toList();
    });
  }

  // Método para obtener las fichas de una categoría específica
  List<FichaRehabilitacion> obtenerFichasPorCategoria(String categoria) {
    // Si la categoría no existe, devuelve una lista vacía
    return _fichasPorCategoria[categoria] ?? [];
  }
}
