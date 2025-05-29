import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_provider.dart';

// ==========================================================================
// Todavia no se ha implementado la lógica correspondiente en esta pantalla
// ==========================================================================

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apariencia')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('Tema oscuro'),
            subtitle: Text('Cambia entre tema claro y oscuro'),
            trailing: Consumer<ThemeProvider>(
              builder:
                  (context, provider, _) => Switch(
                    value: provider.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      provider.setThemeMode(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                    },
                  ),
            ),
          ),

          const Divider(),

          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('Tamaño de texto'),
            subtitle: Text('Ajusta el tamaño del texto en la app'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (context) => SimpleDialog(
                      title: Text('Tamaño de texto'),
                      children: [
                        RadioListTile(
                          title: Text('Pequeño'),
                          value: 0.85,
                          groupValue: 1.0, // Valor actual
                          onChanged: (value) {
                            // Implementar cambio de tamaño
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          title: Text('Normal'),
                          value: 1.0,
                          groupValue: 1.0, // Valor actual
                          onChanged: (value) {
                            // Implementar cambio de tamaño
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          title: Text('Grande'),
                          value: 1.15,
                          groupValue: 1.0, // Valor actual
                          onChanged: (value) {
                            // Implementar cambio de tamaño
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: Icon(Icons.color_lens_outlined),
            title: Text('Tema de colores'),
            subtitle: Text('Personaliza los colores de la aplicación'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Implementar tema de colores
            },
          ),
        ],
      ),
    );
  }
}
