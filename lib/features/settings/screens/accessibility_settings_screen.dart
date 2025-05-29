import 'package:flutter/material.dart';
import '../../../core/services/preferences_service.dart';

// ==========================================================================
// Todavia no se ha implementado la lógica correspondiente en esta pantalla
// ==========================================================================

class AccessibilitySettingsScreen extends StatefulWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  State<AccessibilitySettingsScreen> createState() =>
      _AccessibilitySettingsScreenState();
}

class _AccessibilitySettingsScreenState
    extends State<AccessibilitySettingsScreen> {
  // Valores de las opciones de accesibilidad
  bool _altoContraste = false;
  bool _reducirAnimaciones = false;
  bool _textoGrande = false;
  double _escalaDeFuente = 1.0;

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
  }

  Future<void> _cargarPreferencias() async {
    final prefs = await PreferencesService.instance;
    setState(() {
      _altoContraste = prefs.getBool('accesibilidad_altoContraste') ?? false;
      _reducirAnimaciones =
          prefs.getBool('accesibilidad_reducirAnimaciones') ?? false;
      _textoGrande = prefs.getBool('accesibilidad_textoGrande') ?? false;
      _escalaDeFuente = prefs.getDouble('accesibilidad_escalaDeFuente') ?? 1.0;
    });
  }

  Future<void> _guardarPreferencia(String clave, dynamic valor) async {
    final prefs = await PreferencesService.instance;
    if (valor is bool) {
      await prefs.setBool(clave, valor);
    } else if (valor is double) {
      await prefs.setDouble(clave, valor);
    }
    setState(() {}); // Actualiza la UI después de guardar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accesibilidad')),
      body: ListView(
        children: [
          // Sección: Visualización
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              'VISUALIZACIÓN',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Alto contraste
          SwitchListTile(
            title: const Text('Alto contraste'),
            subtitle: const Text(
              'Mejora la visibilidad con colores de alto contraste',
            ),
            value: _altoContraste,
            onChanged: (value) {
              _guardarPreferencia('accesibilidad_altoContraste', value);
              setState(() {
                _altoContraste = value;
              });
              // Aquí puedes implementar la lógica para cambiar el contraste
            },
          ),

          // Texto grande
          SwitchListTile(
            title: const Text('Texto más grande'),
            subtitle: const Text('Aumenta el tamaño del texto en toda la app'),
            value: _textoGrande,
            onChanged: (value) {
              _guardarPreferencia('accesibilidad_textoGrande', value);
              setState(() {
                _textoGrande = value;
              });
              // Aquí iría la lógica para aplicar texto grande
            },
          ),

          // Escala de fuente
          ListTile(
            title: const Text('Escala de fuente'),
            subtitle: Text('${(_escalaDeFuente * 100).toStringAsFixed(0)}%'),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                value: _escalaDeFuente,
                min: 0.8,
                max: 1.4,
                divisions: 6,
                label: '${(_escalaDeFuente * 100).toStringAsFixed(0)}%',
                onChanged: (value) {
                  setState(() {
                    _escalaDeFuente = value;
                  });
                },
                onChangeEnd: (value) {
                  _guardarPreferencia('accesibilidad_escalaDeFuente', value);
                  // Aplicar cambio de escala a nivel de app
                },
              ),
            ),
          ),

          const Divider(),

          // Sección: Interacción
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              'INTERACCIÓN',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Reducir animaciones
          SwitchListTile(
            title: const Text('Reducir animaciones'),
            subtitle: const Text(
              'Minimiza los efectos visuales en la interfaz',
            ),
            value: _reducirAnimaciones,
            onChanged: (value) {
              _guardarPreferencia('accesibilidad_reducirAnimaciones', value);
              setState(() {
                _reducirAnimaciones = value;
              });
              // Implementar cambio de animaciones
            },
          ),

          // Tiempo de presión prolongada
          ListTile(
            leading: const Icon(Icons.touch_app),
            title: const Text('Tiempo de presión prolongada'),
            subtitle: const Text(
              'Ajusta el tiempo para detectar pulsaciones largas',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (context) => SimpleDialog(
                      title: const Text('Tiempo de presión'),
                      children: [
                        RadioListTile(
                          title: const Text('Corto (0.3s)'),
                          value: 'corto',
                          groupValue: 'normal',
                          onChanged: (value) {
                            // Implementar cambio
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          title: const Text('Normal (0.5s)'),
                          value: 'normal',
                          groupValue: 'normal',
                          onChanged: (value) {
                            // Implementar cambio
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          title: const Text('Largo (1s)'),
                          value: 'largo',
                          groupValue: 'normal',
                          onChanged: (value) {
                            // Implementar cambio
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
              );
            },
          ),

          const Divider(),

          // Sección: Lectura de pantalla
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              'LECTURA DE PANTALLA',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.record_voice_over),
            title: const Text('Asistente de voz'),
            subtitle: const Text('Configuración de lectura de pantalla'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Esto típicamente llevaría a la configuración del sistema
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Esta función se integrará con el lector de pantalla del sistema.',
                  ),
                ),
              );
            },
          ),

          // Botón para restablecer configuración
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Restablecer configuración predeterminada'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
              ),
              onPressed: () async {
                // Mostrar diálogo de confirmación
                final confirmar = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('¿Restablecer configuración?'),
                        content: const Text(
                          'Se restablecerán todas las opciones de accesibilidad a su valor predeterminado.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Restablecer'),
                          ),
                        ],
                      ),
                );

                if (confirmar == true) {
                  final prefs = await PreferencesService.instance;
                  await prefs.remove('accesibilidad_altoContraste');
                  await prefs.remove('accesibilidad_reducirAnimaciones');
                  await prefs.remove('accesibilidad_textoGrande');
                  await prefs.remove('accesibilidad_escalaDeFuente');

                  setState(() {
                    _altoContraste = false;
                    _reducirAnimaciones = false;
                    _textoGrande = false;
                    _escalaDeFuente = 1.0;
                  });

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Configuración restablecida'),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
