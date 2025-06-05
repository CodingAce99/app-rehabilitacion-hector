import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../diario/providers/diario_provider.dart';
import '../diario/models/entrada_diario.dart';

// Extensión para obtener tonos mas oscuros o claros de un color
extension ColorExtension on Color {
  Color get darker {
    const amount = 0.1;
    final HSLColor hsl = HSLColor.fromColor(this);
    final adjustedLightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(adjustedLightness).toColor();
  }

  Color get lighter {
    const amount = 0.1;
    final HSLColor hsl = HSLColor.fromColor(this);
    final adjustedLightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(adjustedLightness).toColor();
  }
}

// Enum para definir los períodos de estadísticas
enum PeriodoEstadisticas { dias7, dias30, dias90, completo }

// Pantalla para mostrar estadísticas del diario
class EstadisticasScreen extends StatefulWidget {
  const EstadisticasScreen({super.key});

  @override
  EstadisticasScreenState createState() => EstadisticasScreenState();
}

class EstadisticasScreenState extends State<EstadisticasScreen> {
  PeriodoEstadisticas _periodoSeleccionado =
      PeriodoEstadisticas.dias30; // Periodo por defecto

  List<String> fechas = []; // Lista para almacenar las fechas

  // Filtrar entradas según el período seleccionado
  List<EntradaDiario> _filtrarEntradasPorPeriodo(
    List<EntradaDiario> entradas,
    PeriodoEstadisticas periodo,
  ) {
    if (periodo == PeriodoEstadisticas.completo) {
      return entradas;
    }

    final ahora = DateTime.now();
    int diasAtras;

    switch (periodo) {
      case PeriodoEstadisticas.dias7:
        diasAtras = 7;
        break;
      case PeriodoEstadisticas.dias30:
        diasAtras = 30;
        break;
      case PeriodoEstadisticas.dias90:
        diasAtras = 90;
        break;
      default:
        diasAtras = 30; // Por defecto
    }

    final fechaLimite = ahora.subtract(Duration(days: diasAtras));
    return entradas.where((entrada) {
      return entrada.fecha.isAfter(fechaLimite);
    }).toList();
  }

  // Construye el selector de período
  Widget _buildPeriodoSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildPeriodoChip(PeriodoEstadisticas.dias7, '7 días'),
            const SizedBox(width: 8),
            _buildPeriodoChip(PeriodoEstadisticas.dias30, '30 días'),
            const SizedBox(width: 8),
            _buildPeriodoChip(PeriodoEstadisticas.dias90, '90 días'),
            const SizedBox(width: 8),
            _buildPeriodoChip(PeriodoEstadisticas.completo, 'Todo'),
          ],
        ),
      ),
    );
  }

  // Construye cada chip de selección de período
  Widget _buildPeriodoChip(PeriodoEstadisticas periodo, String label) {
    final isSelected = _periodoSeleccionado == periodo;
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      checkmarkColor: theme.colorScheme.onPrimary,
      selectedColor: theme.colorScheme.primary,
      labelStyle: TextStyle(
        color:
            isSelected
                ? theme.colorScheme.onPrimary
                : theme.textTheme.bodyMedium?.color,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
        ),
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _periodoSeleccionado = periodo;
          });
        }
      },
    );
  }

  // Calcula las estadísticas basadas en las entradas del diario
  Future<Map<String, dynamic>> _calcularEstadisticas(
    List<EntradaDiario> entradas,
  ) async {
    // Filtrar entradas según el período seleccionado
    final entradasFiltradas = _filtrarEntradasPorPeriodo(
      entradas,
      _periodoSeleccionado,
    );

    return Future.delayed(Duration(milliseconds: 100), () {
      final estadosAnimo = _calcularDistribucionEstadosAnimo(entradasFiltradas);
      final promedioCalidadSueno = _calcularPromedioCalidadSueno(
        entradasFiltradas,
      );
      final promedioNivelDolor = _calcularPromedioNivelDolor(entradasFiltradas);

      return {
        'estadosAnimo': estadosAnimo,
        'promedioCalidadSueno': promedioCalidadSueno,
        'promedioNivelDolor': promedioNivelDolor,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final diarioProvider = Provider.of<DiarioProvider>(context);
    final entradas = diarioProvider.entradas;

    // Verificar si hay entradas
    if (entradas.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Estadísticas')),
        body: Center(
          child: Text(
            'No hay datos disponibles para mostrar estadísticas.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Estadísticas')),
      body: SafeArea(
        child: FutureBuilder(
          // Clave para reconstrucción
          key: ValueKey(_periodoSeleccionado),
          future: _calcularEstadisticas(entradas),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error al cargar las estadísticas: ${snapshot.error}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No hay datos suficientes para mostrar estadísticas.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            final data = snapshot.data!;
            final estadosAnimo = data['estadosAnimo'] as Map<String, int>;
            final promedioCalidadSueno = data['promedioCalidadSueno'] as double;
            final promedioNivelDolor = data['promedioNivelDolor'] as double;

            // Determinar si hay datos suficientes para mostrar
            final hayDatos =
                estadosAnimo.isNotEmpty ||
                promedioCalidadSueno > 0 ||
                promedioNivelDolor > 0;

            if (!hayDatos) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPeriodoSelector(),
                  const SizedBox(height: 24),
                  Text(
                    'No hay datos suficientes para el período seleccionado.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              );
            }

            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      kToolbarHeight -
                      MediaQuery.of(context).padding.top,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Añadir selector de período al principio
                      _buildPeriodoSelector(),

                      // Sección de estados de ánimo
                      Center(
                        child: Text(
                          'Estado de ánimo',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        height: 280,
                        child:
                            estadosAnimo.isNotEmpty
                                ? _crearGraficoCircular(context, estadosAnimo)
                                : Center(
                                  child: Text(
                                    'No hay datos de estados de ánimo para este período.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                      ),
                      Divider(height: 24),

                      // Sección de calidad del sueño
                      Center(
                        child: Text(
                          'Calidad del sueño',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        height: 300,
                        child:
                            promedioCalidadSueno > 0
                                ? _crearGraficoLinea(
                                  context,
                                  'Calidad del sueño',
                                  promedioCalidadSueno,
                                )
                                : Center(
                                  child: Text(
                                    'No hay datos de calidad de sueño para este período.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                      ),
                      Divider(height: 24),

                      // Sección de nivel de dolor
                      Center(
                        child: Text(
                          'Nivel de dolor',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        height: 300,
                        child:
                            promedioNivelDolor > 0
                                ? _crearGraficoLinea(
                                  context,
                                  'Nivel de dolor',
                                  promedioNivelDolor,
                                )
                                : Center(
                                  child: Text(
                                    'No hay datos de nivel de dolor para este período.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                      ),
                      SizedBox(height: 4), // Espacio adicional al final
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Calcular la distribución de estados de ánimo
  Map<String, int> _calcularDistribucionEstadosAnimo(
    List<EntradaDiario> entradas,
  ) {
    try {
      final distribucion = <String, int>{};
      for (var entrada in entradas) {
        if (entrada.estadoAnimo.isNotEmpty) {
          distribucion[entrada.estadoAnimo] =
              (distribucion[entrada.estadoAnimo] ?? 0) + 1;
        }
      }
      return distribucion;
    } catch (e) {
      debugPrint('Error al calcular la distribución de estados de ánimo: $e');
      return {};
    }
  }

  // Calcula el promedio de calidad del sueño
  double _calcularPromedioCalidadSueno(List<EntradaDiario> entradas) {
    try {
      if (entradas.isEmpty) return 0;
      final total = entradas.fold(
        0,
        (sum, entrada) => sum + (int.tryParse(entrada.calidadSueno) ?? 0),
      );
      return total / entradas.length;
    } catch (e) {
      debugPrint('Error al calcular el promedio de calidad del sueño: $e');
      return 0;
    }
  }

  // Calcular el promedio del nivel de dolor
  double _calcularPromedioNivelDolor(List<EntradaDiario> entradas) {
    try {
      if (entradas.isEmpty) return 0;
      final total = entradas.fold(
        0,
        (sum, entrada) => sum + (int.tryParse(entrada.dolor) ?? 0),
      );
      return total / entradas.length;
    } catch (e) {
      debugPrint('Error al calcular el promedio del nivel de dolor: $e');
      return 0;
    }
  }

  // Crear gráfico circular para estados de ánimo
  Widget _crearGraficoCircular(BuildContext context, Map<String, int> data) {
    final total = data.values.fold(0, (sum, value) => sum + value);

    if (total == 0) {
      return Center(
        child: Text(
          'No hay datos suficientes para mostrar el gráfico.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    // Ordenar las entradas por valor descendente
    final sortedEntries =
        data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 1.8, // Relación de aspecto del gráfico
          child: PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 40,
              sections:
                  sortedEntries.map((entry) {
                    final porcentaje = (entry.value / total) * 100;
                    return PieChartSectionData(
                      value: entry.value.toDouble(),
                      title: '${porcentaje.toStringAsFixed(0)}%',
                      titleStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
                      ),
                      color: _obtenerColorEstadoAnimo(entry.key),
                      radius: 50, // Radio de la sección
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    );
                  }).toList(),
              // Información opcional al tocar
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                enabled: true,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        // Leyenda de colores y estados
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(
            spacing: 16, // Espacio horizontal entre elementos
            runSpacing: 8, // Espacio vertical entre filas
            alignment: WrapAlignment.center,
            children:
                sortedEntries.map((entry) {
                  final estado = entry.key;
                  final cantidad = entry.value;
                  final color = _obtenerColorEstadoAnimo(estado);

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "$estado ($cantidad)",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  // Gráfico de líneas para mostrar valores históricos
  Widget _crearGraficoLinea(
    BuildContext context,
    String titulo,
    double valorPromedio,
  ) {
    if (valorPromedio <= 0) {
      return Center(
        child: Text(
          'No hay datos suficientes para mostrar el gráfico.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    final diarioProvider = Provider.of<DiarioProvider>(context);
    List<EntradaDiario> entradasFiltradas = _filtrarEntradasPorPeriodo(
      diarioProvider.entradas,
      _periodoSeleccionado,
    );

    // Colores pastel para el gráfico
    final Color lineColor =
        titulo.contains('sueño')
            ? const Color(0xFFB5CFE1) // Azul pastel
            : const Color(0xFFF6B6A8); // Rojo/naranja pastel

    // Obtener datos históricos reales
    final tipoMedicion = titulo.contains('sueño') ? 'sueño' : 'dolor';
    final spots = _prepararDatosHistoricos(entradasFiltradas, tipoMedicion);

    if (spots.isEmpty) {
      return Center(
        child: Text(
          'No hay suficientes datos históricos para este período.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    // Obtener las fechas para las etiquetas
    final fechas = _obtenerFechasFormateadas(entradasFiltradas);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          horizontalInterval: 2,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.2), // Línea horizontal sutil
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20, // Espacio reservado para las etiquetas
              getTitlesWidget: (value, meta) {
                final int idx = value.toInt();
                // Se asegura de que el índice esté dentro del rango de fechas
                if (idx >= 0 && idx < fechas.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      fechas[idx], // Usa solo las fechas formateadas
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: 2,
              getTitlesWidget: (value, meta) {
                if (value % 2 == 0) {
                  return Text(
                    value.toInt().toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: spots.length - 1.0,
        minY: 0,
        maxY: 10,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: lineColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                // Destacar el último punto (valor más reciente)
                if (index == spots.length - 1) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: lineColor,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                }
                return FlDotCirclePainter(
                  radius: 4,
                  // ignore: deprecated_member_use
                  color: lineColor.withOpacity(0.8),
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              // ignore: deprecated_member_use
              color: lineColor.withOpacity(0.2),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.white,
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                return LineTooltipItem(
                  barSpot.y.toStringAsFixed(1),
                  TextStyle(
                    color: lineColor.darker,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  // Prepara los datos históricos para el gráfico de líneas
  List<FlSpot> _prepararDatosHistoricos(
    List<EntradaDiario> entradas,
    String tipoMedicion, // 'sueño' o 'dolor'
  ) {
    if (entradas.isEmpty) return [];

    // Ordena las entradas por fecha (de más antigua a más reciente)
    final entradasOrdenadas = List<EntradaDiario>.from(entradas)
      ..sort((a, b) => a.fecha.compareTo(b.fecha));

    // Limite a mostrar un máximo de 8 puntos para no sobrecargar el gráfico
    final entradasMostradas =
        entradasOrdenadas.length > 8
            ? entradasOrdenadas.sublist(entradasOrdenadas.length - 8)
            : entradasOrdenadas;

    // Limpia y sincroniza las fechas
    fechas = [];

    return List.generate(entradasMostradas.length, (i) {
      final entrada = entradasMostradas[i];
      final valor =
          tipoMedicion == 'sueño'
              ? double.tryParse(entrada.calidadSueno) ?? 0
              : double.tryParse(entrada.dolor) ?? 0;

      // Agrega la fecha correspondiente
      fechas.add('${entrada.fecha.day}/${entrada.fecha.month}');

      return FlSpot(i.toDouble(), valor);
    });
  }

  // Obtiene las fechas formateadas para las etiquetas del eje X
  List<String> _obtenerFechasFormateadas(List<EntradaDiario> entradas) {
    if (entradas.isEmpty) return [];

    // Ordena las entradas por fecha
    final entradasOrdenadas = List<EntradaDiario>.from(entradas)
      ..sort((a, b) => a.fecha.compareTo(b.fecha));

    // Limita a 8 fechas
    final entradasMostradas =
        entradasOrdenadas.length > 8
            ? entradasOrdenadas.sublist(entradasOrdenadas.length - 8)
            : entradasOrdenadas;

    // Formatea las fechas como dd/MM
    return entradasMostradas.map((entrada) {
      return '${entrada.fecha.day}/${entrada.fecha.month}';
    }).toList();
  }

  // Obtener color para cada estado de ánimo
  Color _obtenerColorEstadoAnimo(String estado) {
    switch (estado) {
      case 'Feliz':
        return const Color(0xFFA8D5BA); // Verde pastel
      case 'Neutral':
        return const Color(0xFFB5CFE1); // Azul pastel
      case 'Triste':
        return const Color(0xFFE2B6CF); // Rosa pastel
      case 'Enfadado':
        return const Color(0xFFF6B6A8); // Naranja/Rojo pastel
      case 'Ansioso':
        return const Color(0xFFF7D8AE); // Amarillo pastel
      default:
        return const Color(0xFFDCDCDC); // Gris claro pastel
    }
  }
}
