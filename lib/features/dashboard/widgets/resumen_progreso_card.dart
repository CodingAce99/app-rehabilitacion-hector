import 'package:flutter/material.dart';

class ResumenProgresoCard extends StatelessWidget {
  final String texto;

  const ResumenProgresoCard({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green),
            const SizedBox(width: 12),
            Expanded(
              child: Text(texto, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}
