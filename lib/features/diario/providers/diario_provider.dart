import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/entrada_diario.dart';
import 'package:uuid/uuid.dart';

class DiarioProvider with ChangeNotifier {
  List<EntradaDiario> _entradas = [];
  bool _isLoading = true;

  List<EntradaDiario> get entradas => [..._entradas];
  bool get isLoading => _isLoading;

  DiarioProvider() {
    cargarEntradas();
  }

  void agregarEntrada(
    String titulo,
    String texto,
    String estadoAnimo,
    String dolor,
    String calidadSueno,
    String terapia,
    List<String> etiquetas,
    String? imagenPath,
    List<String> areasDolorSeleccionadas,
    String descripcionDolor,
  ) {
    final nueva = EntradaDiario(
      id: const Uuid().v4(),
      fecha: DateTime.now(),
      titulo: titulo,
      texto: texto,
      estadoAnimo: estadoAnimo,
      dolor: dolor,
      calidadSueno: calidadSueno,
      terapia: terapia,
      etiquetas: etiquetas,
      imagenPath: imagenPath,
      areasDolor: areasDolorSeleccionadas,
      descripcionDolor: descripcionDolor,
    );
    _entradas.insert(0, nueva);
    guardarEntradas();
    notifyListeners();
  }

  // Reemplaza una entrada por otra con el mismo ID
  void editarEntrada(
    String id,
    String titulo,
    String texto,
    String estadoAnimo,
    String dolor,
    String calidadSueno,
    String terapia,
    List<String> etiquetas,
    List<String> areasDolorSeleccionadas,
    String? imagenPath,
    List<String> areasDolor,
    String descripcionDolor,
  ) {
    // Nota: indexWhere busca el primer elemento que cumple la condición
    // en este caso, el indice de la entrada cuyo id coincida con el que se quiere editar
    final index = _entradas.indexWhere((entradas) => entradas.id == id);
    // El if (index != -1) verifica es una verificación de seguridad.
    // En Dart, indexWhere devuelve -1 si no encuentra el elemento.
    if (index != -1) {
      _entradas[index] = EntradaDiario(
        id: id,
        fecha: _entradas[index].fecha, // Mantenemos la fecha original
        titulo: titulo, // Usa el nuevo título original
        texto: texto,
        estadoAnimo: estadoAnimo,
        dolor: dolor,
        calidadSueno: calidadSueno,
        terapia: terapia,
        etiquetas: etiquetas,
        imagenPath: imagenPath,
        areasDolor: areasDolorSeleccionadas,
        descripcionDolor: descripcionDolor,
      );
      guardarEntradas(); // Guarda en SharedPreferences
      notifyListeners(); // Actualiza la UI donde se usa el provider
    }
  }

  // Elimina una entrada por su ID
  void eliminarEntrada(String id) {
    _entradas.removeWhere((entrada) => entrada.id == id);
    guardarEntradas();
    notifyListeners();
  }

  Future<void> cargarEntradas() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('diario');
    if (data != null) {
      final decoded = json.decode(data) as List;
      _entradas = decoded.map((e) => EntradaDiario.fromJson(e)).toList();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> guardarEntradas() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = json.encode(_entradas.map((e) => e.toJson()).toList());
    await prefs.setString('diario', jsonData);
  }

  // Obtiene la distribución de estados de ánimo presentes en las entradas del diario
  Map<String, int> obtenerDistribucionEstadosAnimo() {
    final distribucion = <String, int>{
      'Feliz': 0,
      'Triste': 0,
      'Enojado': 0,
      'Ansioso': 0,
      'Neutral': 0,
    };

    for (var entrada in entradas) {
      if (entrada.estadoAnimo.isNotEmpty &&
          distribucion.containsKey(entrada.estadoAnimo)) {
        distribucion[entrada.estadoAnimo] =
            (distribucion[entrada.estadoAnimo] ?? 0) + 1;
      }
    }

    return distribucion;
  }
}
