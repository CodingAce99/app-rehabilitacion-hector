import 'package:flutter/material.dart';
import '../../../core/services/preferences_service.dart';
import '../../../core/services/reminder_service.dart';

class TherapyDaysSettingScreen extends StatefulWidget {
  const TherapyDaysSettingScreen({super.key});

  @override
  State<TherapyDaysSettingScreen> createState() =>
      _TherapyDaysSettingScreenState();
}

class _TherapyDaysSettingScreenState extends State<TherapyDaysSettingScreen> {
  final List<bool> _diasSeleccionados = List.generate(7, (_) => false);
  String _horaTerapia = '10:00';

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
  }

  Future<void> _cargarPreferencias() async {
    final prefs = await PreferencesService.instance;

    setState(() {
      // Por defecto, Lunes, Miércoles y Viernes
      _diasSeleccionados[0] = prefs.getBool('terapia_lunes') ?? true;
      _diasSeleccionados[1] = prefs.getBool('terapia_martes') ?? false;
      _diasSeleccionados[2] = prefs.getBool('terapia_miercoles') ?? true;
      _diasSeleccionados[3] = prefs.getBool('terapia_jueves') ?? false;
      _diasSeleccionados[4] = prefs.getBool('terapia_viernes') ?? true;
      _diasSeleccionados[5] = prefs.getBool('terapia_sabado') ?? false;
      _diasSeleccionados[6] = prefs.getBool('terapia_domingo') ?? false;

      _horaTerapia = prefs.getString('terapia_hora') ?? '10:00';
    });
  }

  Future<void> _guardarPreferencias() async {
    await ReminderService.instance.guardarDiasTerapia(
      _diasSeleccionados,
      _horaTerapia,
    );
  }

  TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Días de terapia')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Selecciona los días en que realizas terapias:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),

          CheckboxListTile(
            title: const Text('Lunes'),
            value: _diasSeleccionados[0],
            onChanged: (bool? value) {
              setState(() {
                _diasSeleccionados[0] = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Martes'),
            value: _diasSeleccionados[1],
            onChanged: (bool? value) {
              setState(() {
                _diasSeleccionados[1] = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Miércoles'),
            value: _diasSeleccionados[2],
            onChanged: (bool? value) {
              setState(() {
                _diasSeleccionados[2] = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Jueves'),
            value: _diasSeleccionados[3],
            onChanged: (bool? value) {
              setState(() {
                _diasSeleccionados[3] = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Viernes'),
            value: _diasSeleccionados[4],
            onChanged: (bool? value) {
              setState(() {
                _diasSeleccionados[4] = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Sábado'),
            value: _diasSeleccionados[5],
            onChanged: (bool? value) {
              setState(() {
                _diasSeleccionados[5] = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Domingo'),
            value: _diasSeleccionados[6],
            onChanged: (bool? value) {
              setState(() {
                _diasSeleccionados[6] = value ?? false;
              });
            },
          ),

          const Divider(),

          // Selección de hora
          ListTile(
            leading: Icon(
              Icons.access_time,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Hora de recordatorio'),
            subtitle: Text(_horaTerapia),
            onTap: () async {
              final TimeOfDay? selectedTime = await showTimePicker(
                context: context,
                initialTime: _parseTimeOfDay(_horaTerapia),
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(
                      context,
                    ).copyWith(alwaysUse24HourFormat: true),
                    child: child!,
                  );
                },
              );

              if (selectedTime != null) {
                final String formattedTime =
                    '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                setState(() {
                  _horaTerapia = formattedTime;
                });
              }
            },
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                await _guardarPreferencias();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Configuración guardada'),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }
}
