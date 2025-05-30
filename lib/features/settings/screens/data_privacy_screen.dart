import 'package:flutter/material.dart';
import '../../../core/services/preferences_service.dart';
import '../widgets/custom_notification.dart';

// ==========================================================================
// Pantalla de configuración de datos y privacidad
// ==========================================================================
class DataPrivacyScreen extends StatefulWidget {
  const DataPrivacyScreen({super.key});

  @override
  State<DataPrivacyScreen> createState() => _DataPrivacyScreenState();
}

class _DataPrivacyScreenState extends State<DataPrivacyScreen> {
  // Variable para las opciones de configuración
  bool _dataRespaldoAutomatico = false; // Opción de respaldo automático
  bool _dataCompartirEstadisticas = false; // Opción de compartir estadísticas
  bool _exportacionEnCurso = false; // Indica si se está exportando datos
  bool _importacionEnCurso = false; // Indica si se está importando datos

  @override
  void initState() {
    super.initState();
    _cargarPreferencias(); // Cargar preferencias al iniciar
  }

  // Carga las preferencias guardadas al iniciar la pantalla
  Future<void> _cargarPreferencias() async {
    final prefs = await PreferencesService.instance;
    setState(() {
      _dataRespaldoAutomatico =
          prefs.getBool('data_respaldo_automatico') ?? false;
      _dataCompartirEstadisticas =
          prefs.getBool('data_compartir_estadisticas') ?? false;
    });
  }

  // Guarda una preferencia específica
  Future<void> _guardarPreferencia(String clave, dynamic valor) async {
    final prefs = await PreferencesService.instance;
    if (valor is bool) {
      await prefs.setBool(clave, valor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos y privacidad')),
      body: ListView(
        children: [
          // Sección: Respaldo y restauración
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              'RESPALDO Y RESTAURACIÓN',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Opción: Respaldo automático
          SwitchListTile(
            title: const Text('Respaldo automático'),
            subtitle: const Text('Guarda tus datos en la nube periódicamente'),
            value: _dataRespaldoAutomatico,
            onChanged: (value) {
              setState(() {
                _dataRespaldoAutomatico = value;
              });
              _guardarPreferencia('data_respaldo_automatico', value);
            },
          ),

          // Botón de respaldo manual
          ListTile(
            leading: Icon(
              Icons.backup,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Crear respaldo ahora'),
            subtitle: const Text('Guarda una copia de todos tus datos'),
            onTap: _exportacionEnCurso ? null : () => _exportarDatos(context),
            trailing:
                _exportacionEnCurso
                    ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                    : const Icon(Icons.chevron_right),
          ),

          // Botón de restauración
          ListTile(
            leading: Icon(
              Icons.restore,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Restaurar datos'),
            subtitle: const Text('Recupera tus datos desde un respaldo'),
            onTap: _importacionEnCurso ? null : () => _importarDatos(context),
            trailing:
                _importacionEnCurso
                    ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                    : const Icon(Icons.chevron_right),
          ),

          const Divider(),

          // Sección: Privacidad
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              'PRIVACIDAD',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Opción: Compartir estadísticas anónimas
          SwitchListTile(
            title: const Text('Compartir estadísticas anónimas'),
            subtitle: const Text(
              'Ayúdanos a mejorar la aplicación compartiendo datos de uso anónimos',
            ),
            value: _dataCompartirEstadisticas,
            onChanged: (value) {
              setState(() {
                _dataCompartirEstadisticas = value;
              });
              _guardarPreferencia('data_compartir_estadisticas', value);
            },
          ),

          // Acceso a política de privacidad
          ListTile(
            leading: Icon(
              Icons.policy,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Política de privacidad'),
            subtitle: const Text('Lee cómo utilizamos tus datos'),
            onTap: () => _mostrarPoliticaPrivacidad(context),
            trailing: const Icon(Icons.open_in_new),
          ),

          // Descargar datos personales
          ListTile(
            leading: Icon(
              Icons.download,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Descargar mis datos'),
            subtitle: const Text(
              'Obtén una copia de toda tu información personal',
            ),
            onTap: () => _descargarDatosPersonales(context),
            trailing: const Icon(Icons.chevron_right),
          ),

          const Divider(),

          // Sección: Eliminar datos
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              'ELIMINAR DATOS',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Eliminar datos específicos
          ListTile(
            leading: Icon(Icons.delete_outline, color: Colors.red[700]),
            title: const Text('Eliminar datos específicos'),
            subtitle: const Text(
              'Borra tipos específicos de datos (diario, terapias...)',
            ),
            onTap: () => _eliminarDatosEspecificos(context),
            trailing: const Icon(Icons.chevron_right),
          ),

          // Eliminar todos los datos
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.red[700]),
            title: const Text('Eliminar todos mis datos'),
            subtitle: const Text(
              'Borra permanentemente toda tu información de la aplicación',
            ),
            onTap: () => _eliminarTodosDatos(context),
            trailing: const Icon(Icons.chevron_right),
          ),

          // Advertencia sobre eliminación de datos
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'La eliminación de datos es un proceso irreversible. Una vez que se borren los datos, no podrán ser recuperados a menos que tengas un respaldo.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // --- Métodos de implementación ---

  Future<void> _exportarDatos(BuildContext context) async {
    setState(() {
      _exportacionEnCurso = true;
    });

    // Simulamos una operación de exportación
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _exportacionEnCurso = false;
    });

    if (context.mounted) {
      CustomNotification.mostrar(
        context,
        reproducirSonido: false,
        vibrar: false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Respaldo creado correctamente')),
      );
    }
  }

  // Importa datos desde un respaldo (en desarrollo)
  Future<void> _importarDatos(BuildContext context) async {
    // Mostrar diálogo de confirmación
    final confirmar = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Restaurar datos'),
            content: const Text(
              'Esto reemplazará todos tus datos actuales con los del respaldo. Esta acción no se puede deshacer. ¿Deseas continuar?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Restaurar'),
              ),
            ],
          ),
    );

    if (confirmar == true) {
      setState(() {
        _importacionEnCurso = true;
      });

      // Simulamos una operación de importación
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _importacionEnCurso = false;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos restaurados correctamente')),
        );
      }
    }
  }

  // Muestra la política de privacidad
  void _mostrarPoliticaPrivacidad(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Política de Privacidad'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Política de Privacidad de App Rehabilitación',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Última actualización: Mayo 2025',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Esta aplicación recopila información personal únicamente con el propósito de mejorar tu experiencia y proporcionar servicios personalizados de rehabilitación. No compartimos tu información con terceros sin tu consentimiento explícito.',
                  ),
                  const SizedBox(height: 8),
                  const Text('Los datos recopilados incluyen:'),
                  const SizedBox(height: 8),
                  const Text('• Información de perfil personal'),
                  const Text('• Registros de actividades de rehabilitación'),
                  const Text('• Estados de ánimo y entradas de diario'),
                  const SizedBox(height: 16),
                  const Text(
                    'Puedes solicitar la eliminación de tus datos en cualquier momento a través de las opciones disponibles en esta pantalla.',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
    );
  }

  // Descarga de datos personales (en desarrollo)
  void _descargarDatosPersonales(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función en desarrollo. Próximamente disponible.'),
      ),
    );
  }

  // Métodos para eliminar datos específicos y todos los datos
  void _eliminarDatosEspecificos(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar datos específicos'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckboxListTile(
                  title: const Text('Diario de estado anímico'),
                  value: false,
                  onChanged: (_) {},
                ),
                CheckboxListTile(
                  title: const Text('Registros de terapias'),
                  value: false,
                  onChanged: (_) {},
                ),
                CheckboxListTile(
                  title: const Text('Información de perfil'),
                  value: false,
                  onChanged: (_) {},
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Datos eliminados correctamente'),
                    ),
                  );
                },
                child: const Text('Eliminar seleccionados'),
              ),
            ],
          ),
    );
  }

  void _eliminarTodosDatos(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar todos los datos'),
            content: const Text(
              '¿Estás seguro que deseas eliminar TODOS tus datos? Esta acción es irreversible y no podrás recuperar tus registros después de eliminarlos.\n\nSi deseas continuar, escribe "ELIMINAR" para confirmar.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () => _confirmarEliminacionTotal(context),
                child: const Text('Continuar'),
              ),
            ],
          ),
    );
  }

  // Confirma la eliminación total de datos
  void _confirmarEliminacionTotal(BuildContext context) {
    // En una implementación real, aquí habría que validar que el usuario
    // escribió "ELIMINAR" antes de proceder con la eliminación
    Navigator.pop(context);

    // Mostrar un indicador de progreso
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Eliminando todos los datos...'),
              ],
            ),
          ),
    );

    // Simular el proceso de eliminación
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Cerrar el diálogo de progreso

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todos los datos han sido eliminados'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }
}
