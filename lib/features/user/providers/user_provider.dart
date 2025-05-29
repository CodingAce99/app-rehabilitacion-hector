import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../../core/services/preferences_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  Future<void> loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user');

      if (userData != null) {
        _user = UserModel.fromJson(json.decode(userData));
      } else {
        _user = UserModel(nombre: 'Usuario');
      }
      notifyListeners();
    } catch (e) {
      print('Error al cargar datos de usuario: $e');
      _user = UserModel(nombre: 'Usuario');
      notifyListeners();
    }
  }

  Future<void> updateUser({
    String? nombre,
    String? genero,
    DateTime? fechaNacimiento,
  }) async {
    try {
      if (_user == null) {
        _user = UserModel(
          nombre: nombre ?? 'Usuario',
          genero: genero,
          fechaNacimiento: fechaNacimiento,
        );
      } else {
        _user = UserModel(
          nombre: nombre ?? _user!.nombre,
          genero: genero ?? _user!.genero,
          fechaNacimiento: fechaNacimiento ?? _user!.fechaNacimiento,
        );
      }

      // Guardar en SharedPreferences
      final prefs = await PreferencesService.instance;
      await prefs.setString('user', jsonEncode(_user!.toJson()));

      notifyListeners();
    } catch (e) {
      print('Error al actualizar datos de usuario: $e');
    }
  }

  Future<void> saveUser(UserModel user) async {
    _user = user;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', json.encode(user.toJson()));
    notifyListeners();
  }
}
