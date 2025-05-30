import 'package:flutter/material.dart';

// ==========================================================================
// Pantalla de configuración de rutinas y terapias
// ==========================================================================

class TherapySettingsScreen extends StatelessWidget {
  const TherapySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Notificaciones'),
      ), // Título de la pantalla
      body: Center(
        child: Text(
          'Aquí irá la configuración de las rutinas y terapias.', // Mensaje temporal
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
