import 'package:shared_preferences/shared_preferences.dart';

class ReminderService {
  static final ReminderService _instance = ReminderService._internal();
  static ReminderService get instance => _instance;

  ReminderService._internal();

  // Guarda las preferencias de recordatorios
  Future<void> guardarPreferenciasRecordatorios({
    required bool notificacionesActivadas,
    required bool notificacionesTerapias,
    required bool notificacionesDiario,
    required bool notificacionesLogros,
    required bool sonidoActivado,
    required bool vibracionActivada,
    required String horaRecordatorio,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('notif_activadas', notificacionesActivadas);
    await prefs.setBool('notif_terapias', notificacionesTerapias);
    await prefs.setBool('notif_diario', notificacionesDiario);
    await prefs.setBool('notif_logros', notificacionesLogros);
    await prefs.setBool('notif_sonido', sonidoActivado);
    await prefs.setBool('notif_vibracion', vibracionActivada);
    await prefs.setString('notif_hora_recordatorio', horaRecordatorio);
  }

  // Guarda las preferencias de días de terapia
  Future<void> guardarDiasTerapia(
    List<bool> diasSeleccionados,
    String hora,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('terapia_lunes', diasSeleccionados[0]);
    await prefs.setBool('terapia_martes', diasSeleccionados[1]);
    await prefs.setBool('terapia_miercoles', diasSeleccionados[2]);
    await prefs.setBool('terapia_jueves', diasSeleccionados[3]);
    await prefs.setBool('terapia_viernes', diasSeleccionados[4]);
    await prefs.setBool('terapia_sabado', diasSeleccionados[5]);
    await prefs.setBool('terapia_domingo', diasSeleccionados[6]);
    await prefs.setString('terapia_hora', hora);
  }

  // Verifica si hoy es día de terapia
  Future<bool> esHoyDiaTerapia() async {
    final prefs = await SharedPreferences.getInstance();
    final DateTime ahora = DateTime.now();
    final int diaDeLaSemana = ahora.weekday; // 1 = Lunes, 7 = Domingo

    switch (diaDeLaSemana) {
      case 1:
        return prefs.getBool('terapia_lunes') ?? true;
      case 2:
        return prefs.getBool('terapia_martes') ?? false;
      case 3:
        return prefs.getBool('terapia_miercoles') ?? true;
      case 4:
        return prefs.getBool('terapia_jueves') ?? false;
      case 5:
        return prefs.getBool('terapia_viernes') ?? true;
      case 6:
        return prefs.getBool('terapia_sabado') ?? false;
      case 7:
        return prefs.getBool('terapia_domingo') ?? false;
      default:
        return false;
    }
  }

  // Verifica si es hora de mostrar recordatorio
  Future<bool> esHoraDeMostrarRecordatorio(String tipoRecordatorio) async {
    final prefs = await SharedPreferences.getInstance();
    final bool notificacionesActivadas =
        prefs.getBool('notif_activadas') ?? true;

    if (!notificacionesActivadas) return false;

    final DateTime ahora = DateTime.now();
    String horaGuardada;

    switch (tipoRecordatorio) {
      case 'terapias':
        final bool notificacionesTerapias =
            prefs.getBool('notif_terapias') ?? true;
        if (!notificacionesTerapias) return false;
        if (!await esHoyDiaTerapia()) return false;
        horaGuardada = prefs.getString('terapia_hora') ?? '10:00';
        break;
      case 'diario':
        final bool notificacionesDiario = prefs.getBool('notif_diario') ?? true;
        if (!notificacionesDiario) return false;
        horaGuardada = prefs.getString('notif_hora_recordatorio') ?? '08:00';
        break;
      default:
        return false;
    }

    final List<String> partesHora = horaGuardada.split(':');
    final int hora = int.parse(partesHora[0]);
    final int minuto = int.parse(partesHora[1]);

    // Verificar si es la hora exacta (con tolerancia de 1 minuto)
    // Esta comparación se ejecutará cada 10 segundos por el Timer
    return ahora.hour == hora &&
        (ahora.minute == minuto || ahora.minute == minuto + 1) &&
        !await yaSeHaMostradoHoy(tipoRecordatorio);
  }

  // Añade este método para evitar mostrar el mismo recordatorio múltiples veces
  Future<bool> yaSeHaMostradoHoy(String tipoRecordatorio) async {
    final prefs = await SharedPreferences.getInstance();
    final DateTime ahora = DateTime.now();
    final String hoy = '${ahora.year}-${ahora.month}-${ahora.day}';
    final String ultimaNotificacion =
        prefs.getString('ultima_notif_${tipoRecordatorio}_fecha') ?? '';

    if (ultimaNotificacion == hoy) {
      return true;
    }

    // Guarda la fecha de la última notificación
    await prefs.setString('ultima_notif_${tipoRecordatorio}_fecha', hoy);
    return false;
  }
}
