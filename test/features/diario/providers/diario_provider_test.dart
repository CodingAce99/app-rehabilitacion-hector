import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_rehab/features/diario/providers/diario_provider.dart';
import 'package:app_rehab/features/diario/models/entrada_diario.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DiarioProvider', () {
    test('Carga entradas desde SharedPreferences', () async {
      final mockEntrada = EntradaDiario(
        id: '1',
        fecha: DateTime(2024, 1, 1),
        titulo: 'Prueba',
        texto: 'Esto es una entrada de prueba',
        estadoAnimo: 'Feliz',
        etiquetas: ['Terapia', 'Ejercicio'],
      );

      final mockJsonList = [mockEntrada.toJson()];
      SharedPreferences.setMockInitialValues({
        'diario': json.encode(mockJsonList), //
      });

      final provider = DiarioProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.entradas.length, 1);
      expect(provider.entradas.first.titulo, 'Prueba');
    });
  });
}
