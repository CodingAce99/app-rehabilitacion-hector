import 'package:flutter/material.dart';

class EstadisticasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Estadísticas')),
      body: Center(
        child: Text(
          'Aquí irán los gráficos de evolución',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
