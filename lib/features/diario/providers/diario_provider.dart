import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/entrada_diario.dart';
import 'package:uuid/uuid.dart';

// Provider para gestionar las entradas del diario
class DiarioProvider with ChangeNotifier {
  List<EntradaDiario> _entradas = []; // Lista de entradas del diario
  bool _isLoading = true; // Estado de carga

  // Obtiene una copia de las entradas
  List<EntradaDiario> get entradas => [..._entradas];

  // Obtiene el estado de carga
  bool get isLoading => _isLoading;

  // Constructor del provider
  DiarioProvider() {
    cargarEntradas();
  }

  // Agrega una nueva entrada al diario
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
      id: const Uuid().v4(), // Genera un ID único
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
    _entradas.insert(0, nueva); // Inserta la nueva entrada al inicio
    guardarEntradas(); // Guarda las entradas en almacenamiento (SharedPreferences)
    notifyListeners(); // Notifica a los Widgets que usan este provider
  }

  // Edita una entrada existente por su ID
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
    final index = _entradas.indexWhere(
      (entradas) => entradas.id == id,
    ); // Busca la entrada por ID

    if (index != -1) {
      _entradas[index] = EntradaDiario(
        id: id,
        fecha: _entradas[index].fecha, // Mantiene la fecha original
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
      guardarEntradas(); // Guarda los cambios
      notifyListeners(); // Notifica los cambios
    }
  }

  // Elimina una entrada por su ID
  void eliminarEntrada(String id) {
    _entradas.removeWhere((entrada) => entrada.id == id);
    guardarEntradas(); // Guarda los cambios
    notifyListeners(); // Notifica los cambios
  }

  // Carga las entradas desde SharedPreferences
  Future<void> cargarEntradas() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('diario');
    if (data != null) {
      final decoded = json.decode(data) as List;
      _entradas = decoded.map((e) => EntradaDiario.fromJson(e)).toList();
    }
    _isLoading = false; // Cambia el estado de carga
    notifyListeners(); // Notifica los cambios
  }

  // Guarda las entradas en SharedPreferences
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

  // Obtener distribución de estados de ánimo filtrados por período
  Map<String, int> obtenerDistribucionEstadosAnimoFiltrados({int dias = 7}) {
    final ahora = DateTime.now();
    final fechaLimite = ahora.subtract(Duration(days: dias));

    // Filtrar entradas por fecha
    final entradasFiltradas =
        entradas.where((entrada) {
          return entrada.fecha.isAfter(fechaLimite);
        }).toList();

    // Calcular distribución con las entradas filtradas
    final distribucion = <String, int>{};
    for (var entrada in entradasFiltradas) {
      if (entrada.estadoAnimo.isNotEmpty) {
        distribucion[entrada.estadoAnimo] =
            (distribucion[entrada.estadoAnimo] ?? 0) + 1;
      }
    }

    return distribucion;
  }
}
