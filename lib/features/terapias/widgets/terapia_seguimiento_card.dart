// Importaciones de librerías y paquetes
import 'package:flutter/material.dart';

//Importaciones de librerías y paquetes
import '../models/terapia_seguimiento.dart';

// Importaciones de otras pantallas y widgets
class TerapiaSeguimientoCard extends StatelessWidget {
  final TerapiaSeguimiento terapia;
  final VoidCallback? onMarcarCompletada;

  const TerapiaSeguimientoCard({
    super.key,
    required this.terapia,
    this.onMarcarCompletada,
  });

  @override
  Widget build(BuildContext context) {
    final esCompletada = terapia.completada;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    terapia.nombre,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Icon(
                  esCompletada ? Icons.check_circle : Icons.access_time,
                  color: esCompletada ? Colors.green : Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              esCompletada ? 'Completada' : 'En progreso',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (!esCompletada) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: onMarcarCompletada,
                  icon: const Icon(Icons.done),
                  label: const Text('Marcar como completada'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
