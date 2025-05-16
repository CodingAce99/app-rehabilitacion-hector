import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../diario/models/entrada_diario.dart';

class UltimaEntradaCard extends StatelessWidget {
  final EntradaDiario entrada;
  final VoidCallback? onTap;

  const UltimaEntradaCard({super.key, required this.entrada, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entrada.titulo,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(entrada.fecha),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                entrada.texto,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                children:
                    entrada.etiquetas.map((etiqueta) {
                      return Chip(
                        label: Text(etiqueta),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.2),
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
