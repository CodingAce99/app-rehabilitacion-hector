import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_provider.dart';

// ==========================================================================
// Pantalla de configuración de apariencia
// ==========================================================================

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apariencia')),
      body: ListView(
        children: [
          // Opción Tema oscuro
          ListTile(
            leading: Icon(Icons.dark_mode), // Icono para el tema oscuro
            title: Text('Tema oscuro'),
            subtitle: Text('Cambia entre tema claro y oscuro'),
            trailing: Consumer<ThemeProvider>(
              builder:
                  (context, provider, _) => Switch(
                    value:
                        provider.themeMode == ThemeMode.dark, //Estado del tema
                    onChanged: (value) {
                      // Cambia entre tema claro y oscuro
                      provider.setThemeMode(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                    },
                  ),
            ),
          ),

          const Divider(), // Separador entre opciones
          // Opción: Tamaño de texto
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('Tamaño de texto'),
            subtitle: Text('Ajusta el tamaño del texto en la app'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Muestra un diálogo para seleccionar el tamaño de texto
              showDialog(
                context: context,
                builder:
                    (context) => SimpleDialog(
                      title: Text('Tamaño de texto'),
                      children: [
                        // Opción: Texto pequeño
                        RadioListTile(
                          title: Text('Pequeño'),
                          value: 0.85,
                          groupValue: 1.0, // Valor actual (debe ser dinámico)
                          onChanged: (value) {
                            // Implementar cambio de tamaño
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          title: Text('Normal'),
                          value: 1.0,
                          groupValue: 1.0, // Valor actual (debe ser dinámico)
                          onChanged: (value) {
                            // Implementar cambio de tamaño
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          title: Text('Grande'),
                          value: 1.15,
                          groupValue: 1.0, // Valor actual (debe ser dinámico)
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

          // Opción: Tema de colores
          ListTile(
            leading: Icon(Icons.color_lens_outlined),
            title: Text('Tema de colores'),
            subtitle: Text('Personaliza los colores de la aplicación'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Implementar lógica para personalizar el tema de colores...
            },
          ),
        ],
      ),
    );
  }
}
