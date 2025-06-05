import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../../core/services/preferences_service.dart';

// ==========================================================================
// Proveedor de estado para manejar la información del usuario
// ==========================================================================

class UserProvider extends ChangeNotifier {
  // Instancia privada del modelo de usuario
  UserModel? _user;

  // Singleton instance
  UserModel? get user => _user;

  // Método para inicializar el proveedor y cargar los datos del usuario
  Future<void> loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user');

      // Si no hay datos guardados, se crea un usuario por defecto
      if (userData != null) {
        _user = UserModel.fromJson(json.decode(userData));
      } else {
        _user = UserModel(nombre: 'Usuario');
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error al cargar datos de usuario: $e');
      _user = UserModel(nombre: 'Usuario');
      notifyListeners();
    }
  }

  // Método para actualizar los datos del usuario
  Future<void> updateUser({
    String? nombre,
    String? genero,
    DateTime? fechaNacimiento,
  }) async {
    try {
      // Si no hay usuario cargado, se crea uno nuevo
      if (_user == null) {
        _user = UserModel(
          nombre: nombre ?? 'Usuario',
          genero: genero,
          fechaNacimiento: fechaNacimiento,
        );
        // Si ya hay un usuario cargado, se actualizan los campos proporcionados
      } else {
        _user = UserModel(
          nombre: nombre ?? _user!.nombre,
          genero: genero ?? _user!.genero,
          fechaNacimiento: fechaNacimiento ?? _user!.fechaNacimiento,
        );
      }

      // Guardar los datos actualizados en SharedPreferences
      final prefs = await PreferencesService.instance;
      await prefs.setString('user', jsonEncode(_user!.toJson()));

      notifyListeners();
    } catch (e) {
      debugPrint('Error al actualizar datos de usuario: $e');
    }
  }

  // Método para guardar el usuario en SharedPreferences
  Future<void> saveUser(UserModel user) async {
    _user = user;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(user.toJson()));
    notifyListeners();
  }
}
