import 'package:flutter/material.dart';

// ==========================================================================
// Todavia no se ha implementado la lógica correspondiente en esta pantalla
// ==========================================================================

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración de Notificaciones')),
      body: Center(
        child: Text(
          'Aquí puedes configurar tus notificaciones.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
