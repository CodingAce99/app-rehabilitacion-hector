import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EstadoAnimoBarChart extends StatelessWidget {
  final Map<String, int> resumenEstados;
  final Map<String, Color> estadoColores;

  const EstadoAnimoBarChart({
    super.key,
    required this.resumenEstados,
    required this.estadoColores,
  });

  @override
  Widget build(BuildContext context) {
    // Filtrar estados que tienen al menos una entrada
    final estadosConDatos =
        resumenEstados.entries
            .where((entry) => entry.value > 0)
            .map((e) => e.key)
            .toList();

    final tieneDatos = estadosConDatos.isNotEmpty;

    if (!tieneDatos) {
      return Center(
        child: Text(
          "No has registrado estados de ánimo todavía",
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.grey[200]!,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final estado = estadosConDatos[group.x.toInt()];
                    final valor = resumenEstados[estado]!;
                    return BarTooltipItem(
                      '$estado: $valor',
                      TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, _) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index >= 0 && index < estadosConDatos.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            estadosConDatos[index],
                            style: TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                    reservedSize: 30,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                horizontalInterval: 1,
                drawVerticalLine: false,
                getDrawingHorizontalLine:
                    (value) => FlLine(
                      color: Colors.grey[300] ?? Colors.grey,
                      strokeWidth: 1,
                    ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                  left: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              barGroups: List.generate(estadosConDatos.length, (index) {
                final estado = estadosConDatos[index];
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: resumenEstados[estado]!.toDouble(),
                      color: estadoColores[estado],
                      width: 18,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Solo mostrar leyenda para estados que tienen datos
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children:
              estadosConDatos.map((estado) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: estadoColores[estado],
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(estado, style: Theme.of(context).textTheme.bodySmall),
                  ],
                );
              }).toList(),
        ),
      ],
    );
  }
}
