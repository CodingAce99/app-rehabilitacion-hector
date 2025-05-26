// Importaciones de librerías y paquetes
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Importaciones de otras pantallas y widgets
import '../models/terapia_seguimiento.dart';

class TerapiasSeguimientoProvider with ChangeNotifier {
  List<TerapiaSeguimiento> _lista = [];

  List<TerapiaSeguimiento> get terapias => [..._lista];

  TerapiasSeguimientoProvider() {
    cargarSeguimiento();
  }

  void agregarTerapia(TerapiaSeguimiento seguimiento) {
    _lista.add(seguimiento);
    guardarSeguimiento();
    notifyListeners();
  }

  void marcarComoCompletada(String id) {
    final index = _lista.indexWhere((t) => t.id == id);
    if (index != -1) {
      _lista[index].completada = true;
      _lista[index].fechaFin = DateTime.now();
      guardarSeguimiento();
      notifyListeners();
    }
  }

  int contarCompletadas() => _lista.where((t) => t.completada).length;

  int contarNoCompletadas() => _lista.where((t) => !t.completada).length;

  Future<void> cargarSeguimiento() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('terapias_seguimiento');
    if (jsonStr != null) {
      final decoded = json.decode(jsonStr) as List;
      _lista.clear();
      _lista.addAll(decoded.map((e) => TerapiaSeguimiento.fromJson(e)));
      notifyListeners();
    }
  }

  Future<void> guardarSeguimiento() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = json.encode(_lista.map((e) => e.toJson()).toList());
    await prefs.setString('terapias_seguimiento', jsonStr);
  }
}
