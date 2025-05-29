import 'package:flutter/material.dart';
import 'package:app_rehab/features/dashboard/widgets/resumen_estado_animo_chart.dart';

class EstadoAnimoChartTest extends StatefulWidget {
  const EstadoAnimoChartTest({super.key});

  @override
  State<EstadoAnimoChartTest> createState() => _EstadoAnimoChartTestState();
}

class _EstadoAnimoChartTestState extends State<EstadoAnimoChartTest> {
  bool _mostrarDatos = true;

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo
    final Map<String, int> datosEstados =
        _mostrarDatos
            ? {'Feliz': 5, 'Triste': 2, 'Neutral': 3, 'Ansioso': 1}
            : {}; // Mapa vacío para probar el caso sin datos

    // Colores para los estados
    final Map<String, Color> coloresEstados = {
      'Feliz': const Color(0xFFA8D5BA),
      'Triste': const Color(0xFFB5CFE1),
      'Enojado': const Color(0xFFF6B6A8),
      'Ansioso': const Color(0xFFF7D8AE),
      'Neutral': const Color(0xFFDCDCDC),
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Test de Gráfico')),
      body: Column(
        children: [
          // Controles para alternar datos
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Estado:'),
                const SizedBox(width: 16),
                Switch(
                  value: _mostrarDatos,
                  onChanged: (value) {
                    setState(() {
                      _mostrarDatos = value;
                    });
                  },
                ),
                Text(_mostrarDatos ? 'Con datos' : 'Sin datos'),
              ],
            ),
          ),

          // Separador
          const Divider(),

          // Título de demostración
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Estado de ánimo reciente:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),

          // Gráfico a probar
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: EstadoAnimoLineChart(
                resumenEstados: datosEstados,
                estadoColores: coloresEstados,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
