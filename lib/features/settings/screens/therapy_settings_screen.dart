import 'package:flutter/material.dart';

// ==========================================================================
// Todavia no se ha implementado la lógica correspondiente en esta pantalla
// ==========================================================================

class TherapySettingsScreen extends StatelessWidget {
  const TherapySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración de Notificaciones')),
      body: Center(
        child: Text(
          'Aquí irá la configuración de las rutinas y terapias.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
