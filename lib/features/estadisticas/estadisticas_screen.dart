import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../diario/providers/diario_provider.dart';
import '../diario/models/entrada_diario.dart';

class EstadisticasScreen extends StatelessWidget {
  // Uso de FutureBuilder para manejar la carga de datos
  Future<Map<String, dynamic>> _calcularEstadisticas(
    List<EntradaDiario> entradas,
  ) async {
    return Future.delayed(Duration(milliseconds: 100), () {
      final estadosAnimo = _calcularDistribucionEstadosAnimo(entradas);
      final promedioCalidadSueno = _calcularPromedioCalidadSueno(entradas);
      final promedioNivelDolor = _calcularPromedioNivelDolor(entradas);
      return {
        'estadosAnimo': estadosAnimo,
        'promedioCalidadSueno': promedioCalidadSueno,
        'promedioNivelDolor': promedioNivelDolor,
      };
    });
  }

  const EstadisticasScreen({super.key});

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Distribución de estados de ánimo',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 4),
                      Container(
                        height: 270,
                        child: _crearGraficoCircular(context, estadosAnimo),
                      ),
                      Divider(height: 24),
                      Text(
                        'Promedio de calidad del sueño',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 4),
                      Container(
                        height: 270,
                        child: _crearGraficoBarra(
                          context,
                          'Calidad del sueño',
                          promedioCalidadSueno,
                        ),
                      ),
                      Divider(height: 24),
                      Text(
                        'Promedio del nivel de dolor',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 4),
                      Container(
                        height: 270,
                        child: _crearGraficoBarra(
                          context,
                          'Nivel de dolor',
                          promedioNivelDolor,
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
      print('Error al calcular la distribución de estados de ánimo: $e');
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
      print('Error al calcular el promedio de calidad del sueño: $e');
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
      print('Error al calcular el promedio del nivel de dolor: $e');
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 1.8, // Relación de aspecto más ancha
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius:
                  35, // Reducir para hacer el gráfico más pequeño
              sections:
                  data.entries.map((entry) {
                    final porcentaje = (entry.value / total) * 100;
                    return PieChartSectionData(
                      value: porcentaje,
                      title: '${porcentaje.toStringAsFixed(0)}%',
                      titleStyle: TextStyle(
                        fontSize: 14, // Texto más pequeño
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      color: _obtenerColorEstadoAnimo(entry.key),
                      radius: 45, // Reducir el radio
                    );
                  }).toList(),
            ),
          ),
        ),
        SizedBox(height: 4),
        // Leyenda como una fila centrada
        Center(
          child: Wrap(
            spacing: 12, // Menos espacio horizontal
            runSpacing: 4, // Menos espacio vertical
            alignment: WrapAlignment.center,
            children:
                data.keys
                    .map(
                      (estado) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3,
                          vertical: 1,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10, // Más pequeño
                              height: 10, // Más pequeño
                              decoration: BoxDecoration(
                                color: _obtenerColorEstadoAnimo(estado),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 3), // Menos espacio
                            Text(
                              estado,
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }

  Widget _crearGraficoBarra(BuildContext context, String titulo, double valor) {
    if (valor <= 0) {
      return Center(
        child: Text(
          'No hay datos suficientes para mostrar el gráfico.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        maxY: 10,
        minY: 0,
        gridData: FlGridData(
          show: true,
          horizontalInterval: 2, // Menos líneas horizontales para no saturar
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: valor,
                color: Colors.blue,
                width: 30, // Un poco más estrecho
                borderRadius: BorderRadius.circular(4),
              ),
            ],
            showingTooltipIndicators: [0],
          ),
        ],
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24, // Un poco menor
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 5.0), // Menos padding
                  child: Text(
                    titulo,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 14, // Texto más pequeño
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24, // Un poco menor
              interval: 2, // Mostrar números cada 2 unidades
              getTitlesWidget: (value, meta) {
                if (value % 2 == 0) {
                  // Solo mostrar números pares
                  return Text(
                    value.toInt().toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.grey[200]!,
            tooltipPadding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 3,
            ), // Un poco menor
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toStringAsFixed(1)}',
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
      ),
    );
  }

  // Obtener color para cada estado de ánimo
  Color _obtenerColorEstadoAnimo(String estado) {
    switch (estado) {
      case 'Feliz':
        return Colors.green;
      case 'Neutral':
        return Colors.blue;
      case 'Triste':
        return Colors.red;
      case 'Enfadado':
        return Colors.orange;
      case 'Ansioso':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
