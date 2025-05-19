// Importaciones de librerías y paquetes
import 'package:flutter/material.dart';
import '../models/terapia.dart';

// TerapiasProvider con estado (ChangeNotifier)
class TerapiasProvider with ChangeNotifier {
  // Lista privada de terapias
  List<Terapia> _terapias = [];

  // Getter para acceder a la lista de terapias
  List<Terapia> get terapias => _terapias;

  // Método para cargar terapias de la lista privada
  void cargarTerapias(List<Terapia> terapias) {
    _terapias = terapias;
    notifyListeners();
  }

  // Método para obtener la cantidad de terapias completadas
  int get terapiaCompletadasCount {
    return _terapias.where((t) => t.completada).length;
  }
}
