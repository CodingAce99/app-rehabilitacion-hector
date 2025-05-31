import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../diario/models/entrada_diario.dart';

// Widget para mostrar la última entrada resgistrada en el diario
class UltimaEntradaCard extends StatelessWidget {
  final EntradaDiario entrada; // Datos de la entrada del diario
  final VoidCallback? onTap; // Acción al hacer tap en la tarjeta

  const UltimaEntradaCard({super.key, required this.entrada, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3, // Sombra de la tarjeta
      margin: const EdgeInsets.symmetric(vertical: 12), // Margen vertical
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ), // Bordes redondeados
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap, // Acción al presionar la tarjeta
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Espaciado interno
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título y fecha de la entrada
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: // Título de la entrada
                        Text(
                      entrada.titulo, // Título de la entrada
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    DateFormat(
                      'dd/MM/yyyy',
                    ).format(entrada.fecha), // Fecha formateada
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Texto de la entrada (máximo 2 líneas)
              Text(
                entrada.texto,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),

              // Etiquetas asociadas a la entrada
              Wrap(
                spacing: 6, // Espacio entre etiquetas
                children:
                    entrada.etiquetas.map((etiqueta) {
                      return Chip(
                        label: Text(etiqueta), // Texto de la etiqueta
                        backgroundColor: Theme.of(
                          context,
                          // ignore: deprecated_member_use
                        ).colorScheme.secondary.withOpacity(
                          0.2,
                        ), // Color de fondo
                        labelStyle:
                            Theme.of(
                              context,
                            ).textTheme.bodySmall, // Estilo del texto
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
