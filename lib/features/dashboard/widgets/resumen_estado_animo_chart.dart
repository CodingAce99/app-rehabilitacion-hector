import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Widget para mostrar un gráfico circular de esatados de ánimo
class EstadoAnimoLineChart extends StatelessWidget {
  final Map<String, int> resumenEstados; // Datos de los estados de ánimo
  final Map<String, Color> estadoColores; // Colores asociados a cada estado

  const EstadoAnimoLineChart({
    super.key,
    required this.resumenEstados,
    required this.estadoColores,
  });

  @override
  Widget build(BuildContext context) {
    // Verifica que haya datos disponibles
    if (resumenEstados.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mood, // Icono para indicar ausencia de datos
              size: 48,
              // ignore: deprecated_member_use
              color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay datos de estados de ánimo\nen este período',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(
                  context,
                  // ignore: deprecated_member_use
                ).textTheme.bodyLarge?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    // Calcular el total de entradas
    final total = resumenEstados.values.fold(0, (sum, value) => sum + value);

    // Ordenar los estados de ánimo por frecuencia (de mayor a menor)
    final List<MapEntry<String, int>> sortedEntries =
        resumenEstados.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Última semana',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
            color: Theme.of(
              context,
            ).textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),

        // Gráfico circular
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2, // Espacio entre secciones
              centerSpaceRadius: 35, // Radio del espacio central
              sections:
                  sortedEntries.map((entry) {
                    final porcentaje = (entry.value / total) * 100;
                    return PieChartSectionData(
                      value: entry.value.toDouble(),
                      title: '${porcentaje.toStringAsFixed(0)}%', // Porcentaje
                      titleStyle: TextStyle(
                        fontSize: 13, // Tamaño menor para el dashboard
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
                      ),
                      color: estadoColores[entry.key] ?? Colors.grey,
                      radius: 45, // Radio más pequeño para el dashboard
                      borderSide: BorderSide(color: Colors.white, width: 1),
                    );
                  }).toList(),
              // Información opcional al tocar
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                enabled: true, // Interacción habilitada
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Leyenda compacta para el dashboard
        _buildLeyenda(context, sortedEntries),
      ],
    );
  }

  // Construye la leyenda del gráfico
  Widget _buildLeyenda(
    BuildContext context,
    List<MapEntry<String, int>> entradas,
  ) {
    return Wrap(
      spacing: 12, // Menor espacio para el dashboard
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children:
          entradas.map((entry) {
            final estado = entry.key;
            final cantidad = entry.value;
            final color = estadoColores[estado] ?? Colors.grey;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10, // Tamaño más pequeño para el dashboard
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  "$estado ($cantidad)",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
          }).toList(),
    );
  }
}
