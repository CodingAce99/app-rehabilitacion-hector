import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/theme_provider.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    ThemeMode currentMode = themeProvider.themeMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Modo de tema', style: TextStyle(fontSize: 18)),
        ListTile(
          title: const Text('Sistema'),
          leading: Radio<ThemeMode>(
            value: ThemeMode.system,
            groupValue: currentMode,
            onChanged: (value) => themeProvider.setThemeMode(value!),
          ),
        ),
        ListTile(
          title: const Text('Claro'),
          leading: Radio<ThemeMode>(
            value: ThemeMode.light,
            groupValue: currentMode,
            onChanged: (value) => themeProvider.setThemeMode(value!),
          ),
        ),
        ListTile(
          title: const Text('Oscuro'),
          leading: Radio<ThemeMode>(
            value: ThemeMode.dark,
            groupValue: currentMode,
            onChanged: (value) => themeProvider.setThemeMode(value!),
          ),
        ),
      ],
    );
  }
}
