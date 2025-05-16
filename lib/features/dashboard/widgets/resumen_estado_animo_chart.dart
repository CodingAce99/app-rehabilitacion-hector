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
    final tieneDatos = resumenEstados.values.any((count) => count > 0);

    if (!tieneDatos) {
      return Center(
        child: Text(
          "No hay datos disponibles",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    final estados = resumenEstados.keys.toList();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      return Text(
                        estados[index],
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                rightTitles: AxisTitles(),
                topTitles: AxisTitles(),
              ),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(estados.length, (index) {
                final estado = estados[index];
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
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children:
              estados.map((estado) {
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
