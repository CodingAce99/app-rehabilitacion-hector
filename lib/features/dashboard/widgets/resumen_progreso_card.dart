import 'package:flutter/material.dart';

// Widget para mostrar un tarjeta con un resumen de progreso
class ResumenProgresoCard extends StatelessWidget {
  final String texto; // Texto que describe el progreso

  const ResumenProgresoCard({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 4,
      ), // Margen vertical de la tarjeta
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12), // Espaciado interno
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ), // Icono de progreso
            const SizedBox(width: 12), // Espaciado entre el ícono y el texto
            Expanded(
              child: Text(
                texto, // Texto del progreso
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
