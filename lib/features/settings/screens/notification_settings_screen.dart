// Importaciones necesarias
import 'package:flutter/material.dart';
import '../../../core/services/preferences_service.dart';
import '../../../core/services/reminder_service.dart';
import '../widgets/custom_notification.dart'; // Asegúrate de que la ruta sea correcta

// Otras importaciones
import 'therapy_days_settings_screen.dart';

// ==========================================================================
// Todavia no se ha implementado la lógica correspondiente en esta pantalla
// ==========================================================================

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // Estado para las preferencias de notificaciones
  bool _notificacionesActivadas = true;
  bool _notificacionesTerapias = true;
  bool _notificacionesDiario = true;
  bool _notificacionesLogros = true;
  bool _sonidoActivado = true;
  bool _vibracionActivada = true;
  String _horaRecordatorio = '08:00';

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
  }

  Future<void> _cargarPreferencias() async {
    final prefs = await PreferencesService.instance;

    setState(() {
      _notificacionesActivadas = prefs.getBool('notif_activadas') ?? true;
      _notificacionesTerapias = prefs.getBool('notif_terapias') ?? true;
      _notificacionesDiario = prefs.getBool('notif_diario') ?? true;
      _notificacionesLogros = prefs.getBool('notif_logros') ?? true;
      _sonidoActivado = prefs.getBool('notif_sonido') ?? true;
      _vibracionActivada = prefs.getBool('notif_vibracion') ?? true;
      _horaRecordatorio = prefs.getString('notif_hora_recordatorio') ?? '08:00';
    });
  }

  Future<void> _guardarPreferencia(String clave, dynamic valor) async {
    final prefs = await PreferencesService.instance;

    if (valor is bool) {
      await prefs.setBool(clave, valor);
    } else if (valor is String) {
      await prefs.setString(clave, valor);
    }

    // Guardar todas las preferencias de una sola vez
    await ReminderService.instance.guardarPreferenciasRecordatorios(
      notificacionesActivadas: _notificacionesActivadas,
      notificacionesTerapias: _notificacionesTerapias,
      notificacionesDiario: _notificacionesDiario,
      notificacionesLogros: _notificacionesLogros,
      sonidoActivado: _sonidoActivado,
      vibracionActivada: _vibracionActivada,
      horaRecordatorio: _horaRecordatorio,
    );
  }

  // Función auxiliar para manejar cambios de switch
  void Function(bool)? _onSwitchChanged(
    String prefKey,
    Function(bool) updateState,
  ) {
    if (!_notificacionesActivadas) return null;

    return (bool value) {
      setState(() {
        updateState(value);
      });
      _guardarPreferencia(prefKey, value);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: ListView(
        children: [
          // Control maestro de notificaciones
          SwitchListTile(
            title: const Text('Activar notificaciones'),
            subtitle: const Text('Controla todas las notificaciones de la app'),
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    _notificacionesActivadas
                        // ignore: deprecated_member_use
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                        // ignore: deprecated_member_use
                        : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.notifications,
                color:
                    _notificacionesActivadas
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
              ),
            ),
            value: _notificacionesActivadas,
            onChanged: (bool value) {
              setState(() {
                _notificacionesActivadas = value;
              });
              _guardarPreferencia('notif_activadas', value);
            },
          ),

          const Divider(),

          // Sección: Tipo de notificaciones
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              'TIPO DE NOTIFICACIONES',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Notificaciones de terapias
          SwitchListTile(
            title: const Text('Recordatorios de terapias'),
            subtitle: const Text('Recibe avisos para realizar tus ejercicios'),
            value: _notificacionesTerapias && _notificacionesActivadas,
            onChanged: _onSwitchChanged(
              'notif_terapias',
              (value) => _notificacionesTerapias = value,
            ),
          ),

          // Notificaciones de diario
          SwitchListTile(
            title: const Text('Recordatorio de diario'),
            subtitle: const Text(
              'Recibe avisos para registrar tu estado anímico',
            ),
            value: _notificacionesDiario && _notificacionesActivadas,
            onChanged: _onSwitchChanged(
              'notif_diario',
              (value) => _notificacionesDiario = value,
            ),
          ),

          // Notificaciones de logros
          SwitchListTile(
            title: const Text('Notificaciones de logros'),
            subtitle: const Text('Recibe avisos cuando completes objetivos'),
            value: _notificacionesLogros && _notificacionesActivadas,
            onChanged: _onSwitchChanged(
              'notif_logros',
              (value) => _notificacionesLogros = value,
            ),
          ),

          const Divider(),

          // Sección: Horarios
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              'HORARIOS',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Hora de recordatorio diario
          ListTile(
            leading: Icon(
              Icons.access_time,
              color:
                  _notificacionesActivadas
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
            ),
            title: const Text('Hora de recordatorio diario'),
            subtitle: Text(_horaRecordatorio),
            enabled: _notificacionesActivadas,
            trailing: const Icon(Icons.chevron_right),
            onTap:
                _notificacionesActivadas
                    ? () async {
                      final TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: _parseTimeOfDay(_horaRecordatorio),
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
                          _horaRecordatorio = formattedTime;
                        });
                        await _guardarPreferencia(
                          'notif_hora_recordatorio',
                          formattedTime,
                        );
                      }
                    }
                    : null,
          ),

          // Frecuencia de terapias
          ListTile(
            leading: Icon(
              Icons.calendar_today,
              color:
                  _notificacionesActivadas
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
            ),
            title: const Text('Días de terapia'),
            subtitle: const Text('Personaliza los días de tu rutina'),
            enabled: _notificacionesActivadas && _notificacionesTerapias,
            trailing: const Icon(Icons.chevron_right),
            onTap:
                (_notificacionesActivadas && _notificacionesTerapias)
                    ? () {
                      // Navegar a pantalla de configuración de días
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const TherapyDaysSettingScreen(),
                        ),
                      );
                    }
                    : null,
          ),

          const Divider(),

          // Sección: Estilo de notificaciones
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              'ESTILO DE NOTIFICACIONES',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Sonido
          SwitchListTile(
            title: const Text('Sonido de notificaciones'),
            subtitle: const Text(
              'Reproduce un sonido al recibir notificaciones',
            ),
            secondary: Icon(
              Icons.volume_up,
              color:
                  (_notificacionesActivadas && _sonidoActivado)
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
            ),
            value: _sonidoActivado && _notificacionesActivadas,
            onChanged: _onSwitchChanged(
              'notif_sonido',
              (value) => _sonidoActivado = value,
            ),
          ),

          // Vibración
          SwitchListTile(
            title: const Text('Vibración'),
            subtitle: const Text('Vibra al recibir notificaciones'),
            secondary: Icon(
              Icons.vibration,
              color:
                  (_notificacionesActivadas && _vibracionActivada)
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
            ),
            value: _vibracionActivada && _notificacionesActivadas,
            onChanged: _onSwitchChanged(
              'notif_vibracion',
              (value) => _vibracionActivada = value,
            ),
          ),

          const SizedBox(height: 24),

          // Botón para probar notificaciones
          if (_notificacionesActivadas)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Probar notificación'),
                onPressed: () {
                  CustomNotification.mostrar(
                    context,
                    titulo: 'Recordatorio de prueba',
                    mensaje: '¡Las notificaciones funcionan correctamente!',
                    reproducirSonido: _sonidoActivado,
                    vibrar: _vibracionActivada,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
