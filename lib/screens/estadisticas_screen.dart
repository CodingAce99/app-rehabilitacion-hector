import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../features/diario/providers/diario_provider.dart';

class EstadisticasScreen extends StatelessWidget {
  const EstadisticasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtiene todas las entradas actuales desde el provider
    final entradas = Provider.of<DiarioProvider>(context).entradas;

    // Cuenta cuántas veces aparece cada tipo de estado de ánimo
    // Uso de .where() para filtrar según el emoji
    int felices = entradas.where((e) => e.estadoAnimo == '😃').length;
    int neutros = entradas.where((e) => e.estadoAnimo == '😐').length;
    int tristes = entradas.where((e) => e.estadoAnimo == '😞').length;

    return Scaffold(
      appBar: AppBar(title: Text('Estadísticas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Título del gráfico
            Text(
              'Estado de ánimo registrado',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // AspectRatio asegura que el gráfico mantenga proporciones adecuadas
            AspectRatio(
              aspectRatio: 1.4,
              child: BarChart(
                BarChartData(
                  // Alinea los grupos de barras con espacio entre ellos
                  alignment: BarChartAlignment.spaceAround,
                  // Desactiva la interacción táctil con las barras por ahora
                  barTouchData: BarTouchData(enabled: false),
                  // Personaliza los títulos del gráfico (ejes X e Y)
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          // Muetra un emoji según el valor X de la barra
                          switch (value.toInt()) {
                            case 0:
                              return Text('😃');
                            case 1:
                              return Text('😐');
                            case 2:
                              return Text('😞');
                            default:
                              return Text('');
                          }
                        },
                      ),
                    ),
                    // Oculta los otros títulos para un diseño más limpio
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),

                  // Quita los bordes del gráfico para un diseño más limpio
                  borderData: FlBorderData(show: false),

                  // Define las barras (una por cada estado de ánimo)
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(toY: felices.toDouble(), width: 20),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(toY: neutros.toDouble(), width: 20),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(toY: tristes.toDouble(), width: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Texto resumen debajo del gráfico
            Text('Entradas totales: ${entradas.length}'),
          ],
        ),
      ),
    );
  }
}
