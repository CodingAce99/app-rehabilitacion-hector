import 'package:app_rehab/widgets/theme_switcher.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            // ...Ajustes configuraciones...
            ThemeSwitcher(), // Widget para cambiar el tema
          ],
        ),
      ),
    );
  }
}
