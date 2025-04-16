import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/entrada_diario.dart';
import 'package:uuid/uuid.dart';

class DiarioProvider with ChangeNotifier {
  List<EntradaDiario> _entradas = [];

  List<EntradaDiario> get entradas => [..._entradas];

  DiarioProvider() {
    cargarEntradas();
  }

  void agregarEntrada(
    String texto,
    String estadoAnimo,
    List<String> etiquetas, {
    String? imagenPath,
  }) {
    final nueva = EntradaDiario(
      id: const Uuid().v4(),
      fecha: DateTime.now(),
      texto: texto,
      estadoAnimo: estadoAnimo,
      etiquetas: etiquetas,
      imagenPath: imagenPath,
    );
    _entradas.insert(0, nueva);
    guardarEntradas();
    notifyListeners();
  }

  // Reemplaza una entrada por otra con el mismo ID
  void editarEntrada(
    String id,
    String texto,
    String estadoAnimo,
    List<String> etiquetas,
  ) {
    final index = _entradas.indexWhere((entradas) => entradas.id == id);
    if (index != -1) {
      _entradas[index] = EntradaDiario(
        id: id,
        fecha: _entradas[index].fecha, // Mantenemos la fecha original
        texto: texto,
        estadoAnimo: estadoAnimo,
        etiquetas: etiquetas,
      );
      guardarEntradas();
      notifyListeners();
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
  }

  Future<void> guardarEntradas() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = json.encode(_entradas.map((e) => e.toJson()).toList());
    await prefs.setString('diario', jsonData);
  }
}
